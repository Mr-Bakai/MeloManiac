//
//  AuthManager.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 9/1/22.
//

import Foundation


final class AuthManager{
    static let shared = AuthManager()
    
    private var refreshingToken = false
    
    struct Constants {
        static let clientID = "d57f0ef252054086859ff6cb3e12a265"
        static let clientSecret = "513b71b50fcf41408fcc8b6e28de44ec"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURL = "https://www.instagram.com/bakaismailov/"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read"
    }

    private init() {}
    
    public var signInURL: URL?{
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURL)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool{
        return accessToken != nil
    }
    
    private var accessToken: String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date?{
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    
    // This returns Bool if we have approximately 10 mins left before the date expires for token
    private var shouldRefreshToken: Bool {
        guard  let expirationDate = tokenExpirationDate else {
            return false
        }
        
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    
    // MARK: -Exchange code for token
    //===This func exchanges the code that was given in redirection url, to a access token===
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping((Bool) -> Void)
    ){
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
       
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURL)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // this is the header => Content-Type  =  application/x-www-form-urlencoded.
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        
        // here we are having <base64 encoded client_id:client_secret> requrenment combined
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        
        
        // And here we are encoding to bas64 format
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        
        // this is the Header  => Authorization: Basic <base64 encoded client_id:client_secret>
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                print("SUCCESS \(result)")
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    
    /// Provides valid token to be used with APICalls
    public func withValidToken(completion: @escaping (String) -> Void){
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    
    // MARK: - Refresh Token
    public func refreshIfNeeded(completion: @escaping (Bool) -> Void){
        
        guard !refreshingToken else { return }
        
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else { return }
        
        // Refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // this is the header => Content-Type  =  application/x-www-form-urlencoded.
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        
        // here we are having <base64 encoded client_id:client_secret> requrenment combined
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        
        
        // And here we are encoding to bas64 format
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        
        // this is the Header  => Authorization: Basic <base64 encoded client_id:client_secret>
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach { $0(result.access_token) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        
        // we will cache this if only it's not nil
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
    public func signOut(completion: (Bool) -> Void){
        UserDefaults.standard.setValue(nil, forKey: "access_token")
        UserDefaults.standard.setValue(nil, forKey: "refresh_token")
        UserDefaults.standard.setValue(nil, forKey: "expirationDate")
        completion(true)
    }
}
