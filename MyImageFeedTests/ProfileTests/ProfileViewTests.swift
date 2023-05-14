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
    
    let littlePictureForTest = "https://kafel.ee/wp-content/uploads/2019/02/013-duck.png"
    
    func testProfileViewControllerDidLoad() {
        // Given:
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        // When:
        _ = viewController.view
        // Then:
        XCTAssertTrue(presenter.viewDidLoad)
    }
    

    func testAvatarAlert() {
        // Given:
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()

        // When:
        presenter.showOutAlert(vc: viewController)
        // Then:
        XCTAssertTrue(presenter.alertShow)
    }
    
    func testUpdateImage() {
        let viewController = ProfileViewControllerSpy()
        let profileImageSrvice = ProfileImageServiceStub()

        
        viewController.updateAvatar()
        
        XCTAssertNotNil(profileImageSrvice.avatarImage)
    }
    
}
