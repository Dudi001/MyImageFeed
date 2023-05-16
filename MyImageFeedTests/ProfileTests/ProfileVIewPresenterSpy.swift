//
//  ProfileVIewPresenterSpy.swift
//  MyImageFeedTests
//
//  Created by Мурад Манапов on 13.05.2023.
//

import UIKit
@testable import MyImageFeed

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: MyImageFeed.ProfileViewControllerProtocol?
    var profileImageServiceObserver: NSObjectProtocol?
    var viewDidLoad: Bool = false
    var alertShow: Bool = false
    var addObserver: Bool = false
    var viewController: UIViewController?
    
    
    func showOutAlert(vc: UIViewController) {
        viewController = vc
        alertShow = true
    }
    
    
    
    func addObserverProfileImageService() {
        viewDidLoad = true
    }
    
    
}
