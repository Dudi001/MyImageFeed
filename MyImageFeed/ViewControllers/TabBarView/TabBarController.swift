//
//  TabBarController.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 12.04.2023.
//

import UIKit


final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else { return }
        let imageListPresenter = ImageViewPresenter()
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter()


        imagesListViewController.configure(imageListPresenter)
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController

        
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
