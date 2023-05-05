//
//  WebViewPresenter.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 04.05.2023.
//

import Foundation



public protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}


final class WebViewPresenter: WebViewPresenterProtocol {
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 0.1) <= 0.0001
    }
    
    
    var view: WebViewViewControllerProtocol?

    
    func viewDidLoad() {
        sendRequestToUnsplash()
        
        
    }
    
    
    private func sendRequestToUnsplash() {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: UnsplashParam.accessKey),
            URLQueryItem(name: "redirect_uri", value: UnsplashParam.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: UnsplashParam.accessScope)
        ]
        
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        
        didUpdateProgressValue(0)
        
        view?.load(request: request)
    }
    
}
