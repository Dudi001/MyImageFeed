//
//  WebViewViewController.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 23.03.2023.
//

import UIKit
import WebKit


protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}


final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {

    private lazy var webView = WKWebView()
    private lazy var progressView = UIProgressView()
    private lazy var backButton = UIButton(type: .custom)
    private var estimatedProgressObservation: NSKeyValueObservation?
    var presenter: WebViewPresenterProtocol?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configItems()
        addView()
        addConstraintforItems()
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        

        
        estimatedProgressObservation = webView.observe(
                    \.estimatedProgress,
                    options: [],
                    changeHandler: { [weak self] _, _ in
                        guard let self = self else { return }
                        self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
                    })
    }
    
    
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    
    
}


extension WebViewViewController {
    private func configItems() {
        view.backgroundColor = .white
        webView.accessibilityIdentifier = "UnsplashWebView"
        webView.backgroundColor = .white
        
        backButton.tintColor = Resourses.Colors.black
        backButton.setImage(Resourses.WebView.backNavButton, for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        progressView.tintColor = Resourses.Colors.black
    }
    
    
    private func addConstraintforItems() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 2),
            progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor)
        ])
    }
    
    private func addView() {
        [webView, backButton, progressView].forEach(self.view.setupView)
    }
}




extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url
        {
            return presenter?.code(from: url)
        } else {
            return nil
        }
    }
}

