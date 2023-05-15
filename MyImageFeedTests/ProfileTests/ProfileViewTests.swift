//
//  ProfileViewTests.swift
//  MyImageFeedTests
//
//  Created by Мурад Манапов on 13.05.2023.
//

import XCTest
import UIKit
@testable import MyImageFeed

final class ProfileViewTests: XCTestCase {
    
    func testProfileViewControllerDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        _ = viewController.view

        XCTAssertTrue(presenter.viewDidLoad)
    }
    

    func testAvatarAlert() {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()

        presenter.showOutAlert(vc: viewController)
        
        XCTAssertTrue(presenter.alertShow)
    }
    
    func testUpdateImage() {
        let viewController = ProfileViewControllerSpy()
        let profileImageSrvice = ProfileImageServiceStub()

        viewController.updateAvatar()
        
        XCTAssertNotNil(profileImageSrvice.avatarImage)
    }
    
    func testUpdateProfileDetails() {
        let viewController = ProfileViewController()
        
        viewController.updateAvatar()
        
        XCTAssertNotNil(viewController.loginLabel)
        XCTAssertNotNil(viewController.nameLabel)
    }
    
}
