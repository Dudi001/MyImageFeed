//
//  AuthViewController.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 23.03.2023.
//

import UIKit
protocol AuthViewDelegate: AnyObject {
    func authViewcontroller (_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    private lazy var loginButton = UIButton()
    private lazy var imageLogo =  UIImageView()
    
    weak var delegate: AuthViewDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configItem()
        addView()
        addConstraintForItem()
    }
    
    private func configItem() {
        view.backgroundColor = Resourses.Colors.black
        
        imageLogo.image = Resourses.Auth.imageLogo
        
        loginButton.backgroundColor = .white
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 16
        
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(Resourses.Colors.black, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        loginButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func addConstraintForItem() {
        NSLayoutConstraint.activate([
            imageLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -126),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func addView() {
        [imageLogo, loginButton].forEach(self.view.setupView)
    }
    
    
    @objc private func buttonTapped() {
        let webViewController = WebViewViewController()
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        webViewController.modalPresentationStyle = .overFullScreen
        webViewController.delegate = self
        webViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewController
        present(webViewController, animated:  true)
    }
}


extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewcontroller(self, didAuthenticateWithCode: code)
    }
}
