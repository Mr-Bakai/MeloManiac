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
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(singInButton)
        singInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        singInButton.frame = CGRect(
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50)
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
