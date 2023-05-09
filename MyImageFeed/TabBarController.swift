//
//  TabBarController.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 12.04.2023.
//

import UIKit


final class TabBarController: UITabBarController {
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        // MARK: разобраться с imagelistviewController
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter()
        let imageListViewController = ImagesListViewController()
        let imageViewPresenter = ImageViewPresenter()
        
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        imageViewPresenter.view = imageListViewController
        imageListViewController.presenter = imageViewPresenter
        
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
