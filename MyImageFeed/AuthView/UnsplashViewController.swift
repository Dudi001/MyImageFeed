//
//  UnsplashViewController.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 27.03.2023.
//


import UIKit

final class UnsplashViewController: UIViewController {
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
}

extension UnsplashViewController: AuthViewDelegate {
    func authViewcontroller(_ vc: AuthViewController, didAuthWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            self?.fetchOAuthToken(code)
            
        }
    }
    
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            switch result {
            case .success(let response):
                self?.oauth2TokenStorage.token = response.accessToken
                print(response.accessToken)
//                self?.switchToTabBarController()
            case .failure:
                break
            }
        }
    }
}
