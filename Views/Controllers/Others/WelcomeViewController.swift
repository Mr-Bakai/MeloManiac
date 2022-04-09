//
//  WelcomeViewController.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 9/1/22.
//

import Foundation
import UIKit

final class WelcomeViewController: UIViewController {
    
    private let singInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign in spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "cover")
        return imageView
    }()
    
    private let overlayView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "spotify_caset"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Listen to your Heart"
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.backgroundColor = .black
        view.addSubview(singInButton)
        singInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        view.addSubview(label)
        view.addSubview(logoImageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.frame = view.bounds
        overlayView.frame = view.bounds
        singInButton.frame = CGRect(
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50)
        
        logoImageView.frame = CGRect(x: (view.width-200)/2, y: (view.height-350)/2, width: 200, height: 200)
        label.frame = CGRect(x: 30, y: logoImageView.bottom+30, width: view.width-60, height: 150)
    }
    
    @objc private func didTapSignIn(){
        let vc = AuthViewController()
        
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func handleSignIn(success: Bool){
        // We will show the tabBarController or alertController with the message
        guard success else {
            let alert = UIAlertController(title: "Uhh",
                                          message: "Something went wron when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainTabBarVC = TabBarController()
        mainTabBarVC.modalPresentationStyle = .fullScreen
        present(mainTabBarVC, animated: true)
    }
}
