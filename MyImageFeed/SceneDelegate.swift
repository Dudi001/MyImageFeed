//
//  SceneDelegate.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 18.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()
        
    }


}

