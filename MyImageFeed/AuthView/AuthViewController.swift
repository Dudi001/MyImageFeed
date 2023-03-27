//
//  AuthViewController.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 23.03.2023.
//

import UIKit
protocol AuthViewDelegate: AnyObject {
    func authViewcontroller (_ vc: AuthViewController, didAuthWithCode code: String)
}

final class AuthViewController: UIViewController {
    @IBOutlet private var loginButton: UIButton!
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}


extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO: process code
        delegate?.authViewcontroller(self, didAuthWithCode: code)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

