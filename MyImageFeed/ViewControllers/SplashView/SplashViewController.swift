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
    private let splashLogo = UIImageView()
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        setupSplashLogo()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstAppear {
            if let token = oauth2TokenStorage.token {
                fetchProfile(token)
            } else {
                swithToAuthViewController()
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
    
    
    private func swithToAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func showAlert(with error: Error) {
        let alert = UIAlertController(
            title: "Ошибка сети",
            message: "Произошла ошибка при загрузке данных из сети.",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default)
        
        alert.addAction(action)
        present(alert, animated: true)
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
                case .success(let response):
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()
                    self.fetchProfile(response.accessToken)
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    self.showAlert(with: error)
                    break
                }
            }
        }
    }
}


extension SplashViewController {
    private func fetchProfile(_ token: String?) {
        guard let token else{ return }
        profileService.fetchProfile(token) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userProfile):
                UIBlockingProgressHUD.dismiss()
                self.profileImageService.fetchProfileImageURL(username: userProfile.username) { _ in }
                self.switchToTabBarController()
            case.failure(let error):
                self.showAlert(with: error)
                break
            }
        }
    }
}

extension SplashViewController {
    private func addView() {
        view.setupView(splashLogo)
    }
    
    private func setupSplashLogo() {
        splashLogo.image = Resourses.Splash.logo
        view.backgroundColor = Resourses.Colors.black
        splashLogo.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            splashLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
