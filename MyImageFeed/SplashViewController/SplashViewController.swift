//
//  UnsplashViewController.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 27.03.2023.
//


import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private var isFirstAppear = true
    
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstAppear {
            if let token = oauth2TokenStorage.token {
                fetchProfile(token)
                switchToTabBarController()
            } else {
                performSegue(withIdentifier: SegueIdentifier.showAuthenticationScreenSegueIdentifier, sender: nil)
                isFirstAppear = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Ошибка сети",
            message: "Произошла ошибка при загрузке данных из сети",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default)
        
        alert.addAction(action)
        self.present(self, animated: true)
    }
}


//MARK: Segue
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                return assertionFailure("Failed to prepare for \(SegueIdentifier.showAuthenticationScreenSegueIdentifier)")
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}


//MARK: AuthDelegate
extension SplashViewController: AuthViewDelegate {
    func authViewcontroller(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showAlert()
                    return assertionFailure("failed to get token")
                }
            }
        }
    }
}


extension SplashViewController {
    private func fetchProfile(_ token: String?) {
        guard let token else{ return }
        profileService.fetchProfile(token) { result in
            switch result {
            case .success(let userProfile):
                UIBlockingProgressHUD.dismiss()
                self.profileImageService.fetchProfileImageURL(username: userProfile.username) { _ in }
                self.switchToTabBarController()
            case.failure(let error):
                return assertionFailure("Problem with profile data or token \(error)")
            }
        }
    }
}
