//
//  ProfileViewPresenter.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 09.05.2023.
//

import UIKit


protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func showOutAlert(vc: UIViewController)
    var profileImageServiceObserver: NSObjectProtocol? { get set }
    func addObserverProfileImageService()
}


final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    let token = OAuth2TokenStorage()
    let webView = WebViewViewController()
    var profileImageServiceObserver: NSObjectProtocol?
    
    func showOutAlert(vc: UIViewController) {
        let alert = UIAlertController(
            title: "Уже уходите?",
            message: "Вы уверенены?",
            preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: "Да", style: .default){[weak self] _ in
            guard let self = self else { return }
            self.token.deleteToken()
            self.webView.cleanCookie()
            let authViewController = AuthViewController()
            authViewController.modalPresentationStyle = .fullScreen
            vc.present(authViewController, animated: true)

        }
        let actionNo = UIAlertAction(title: "Нет", style: .default)
        
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        
        vc.present(alert, animated: true )
    }
    
    func addObserverProfileImageService() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateAvatar()
            }
        
    }
    
}
