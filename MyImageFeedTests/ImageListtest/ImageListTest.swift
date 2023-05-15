//
//  ImageListTest.swift
//  MyImageFeedTests
//
//  Created by Мурад Манапов on 14.05.2023.
//

import XCTest
@testable import MyImageFeed

final class ImageListViewTests: XCTestCase {
    
    let indexPath = IndexPath(row: 9, section: 0)
    let photo = Photo(id: "",
                      size: CGSize(width: 1, height: 1),
                      createdAt: nil,
                      welcomeDescription: "",
                      thumbImageURL: "",
                      largeImageURL: "",
                      isLiked: true)
    
    func testAvatarAlert() {
        let viewController = ImagesListViewController()
        let presenter = ImageListPresenterSpy()


        presenter.showAlert(vc: viewController)

        XCTAssertTrue(presenter.alertShow)
    }
    
    
    func testPhotosDownLoaded() {
        let presenter = ImageListPresenterSpy()

        presenter.photosObserver()

        XCTAssertNotNil(presenter.photos)
    }
    
    func testPhotosObserver() {
        let presenter = ImageListPresenterSpy()
        
        presenter.photosObserver()
        
        XCTAssertTrue(presenter.viewDidLoad)
    }
    
    
    func testNeedsNewPhoto() {
        let presenter = ImageListPresenterSpy()
        presenter.photos = Array(repeating: photo, count: 10)
        let controller = ImageListViewControllerSpy()
        controller.presenter = presenter
        
        presenter.needsNewPhoto(indexPath: indexPath)

        XCTAssertTrue(presenter.needsNewPhoto)
    }
    
    
    func testNotNeedsNewPhoto() {
        let presenter = ImageListPresenterSpy()
        presenter.photos = Array(repeating: photo, count: 9)
        let controller = ImageListViewControllerSpy()
        controller.presenter = presenter
        
        presenter.needsNewPhoto(indexPath: indexPath)

        XCTAssertFalse(presenter.needsNewPhoto)
    }
    
}
