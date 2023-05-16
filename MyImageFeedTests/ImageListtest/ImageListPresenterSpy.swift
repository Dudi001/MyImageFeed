//
//  ImageListPresenterSpy.swift
//  MyImageFeedTests
//
//  Created by Мурад Манапов on 14.05.2023.
//

import UIKit
@testable import MyImageFeed

final class ImageListPresenterSpy: ImageListViewPresenterProtocol {
    var view: MyImageFeed.ImagelistViewControllerProtocol?
    
    var photos: [MyImageFeed.Photo] = []
    
    var InfoImageObserver: NSObjectProtocol?
    var viewDidLoad: Bool = false
    var alertShow: Bool = false
    var viewController: UIViewController?
    var needsNewPhoto: Bool = false
    
    func showAlert(vc: UIViewController) {
        viewController = vc
        alertShow = true
    }
    
    func photosObserver() {
        viewDidLoad = true
    }
    
    func updateTableView() {
    }
    
    func needsNewPhoto(indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            needsNewPhoto = true
        }
    }
    
    
}
