//
//  ImageListViewControllerSpy.swift
//  MyImageFeedTests
//
//  Created by Мурад Манапов on 14.05.2023.
//

import UIKit
@testable import MyImageFeed

final class ImageListViewControllerSpy: ImagelistViewControllerProtocol {
    var presenter: MyImageFeed.ImageListViewPresenterProtocol?
    var tableViewDidUpdate: Bool = false
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableViewDidUpdate = true
    }
    
    
}
