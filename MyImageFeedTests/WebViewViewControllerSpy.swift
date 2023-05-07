//
//  WebViewViewControllerSpy.swift
//  MyImageFeedTests
//
//  Created by Мурад Манапов on 06.05.2023.
//


import MyImageFeed
import Foundation


final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: MyImageFeed.WebViewPresenterProtocol?
    
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
    
    
}
