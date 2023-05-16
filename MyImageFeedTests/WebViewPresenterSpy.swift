//
//  WebViewPresenterSpy.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 06.05.2023.
//


import MyImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var view: MyImageFeed.WebViewViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
    
}
