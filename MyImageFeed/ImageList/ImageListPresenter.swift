//
//  ImageListPresenter.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 09.05.2023.
//

import UIKit


protocol ImageListViewPresenterProtocol: AnyObject {
    var view: ImagelistViewControllerProtocol?  { get set }
    var photos: [Photo] { get set }
    var InfoImageObserver: NSObjectProtocol? { get set }
    func showAlert(vc: UIViewController)
    func photosObserver()
    
    
}


final class ImageViewPresenter: ImageListViewPresenterProtocol {
    var InfoImageObserver: NSObjectProtocol?
    
    var photos: [Photo] = []
    var imagesListService = ImagesListService.shared
    var view: ImagelistViewControllerProtocol?
    
    
    func showAlert(vc: UIViewController) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Не спамь лайками.",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "Не буду!", style: .default)
        
        
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
    func photosObserver() {
        InfoImageObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main) {
                [weak self] _ in
                guard let self = self else { return }
                self.view?.updateTableViewAnimated()
            }
    }
    
}


