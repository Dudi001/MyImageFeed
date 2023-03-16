//
//  Resurses.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 16.03.2023.
//

import UIKit

enum Resourses {
    enum Images {
        enum Profile {
            static let defaultAvatar = UIImage(named: "profile_image")
            static let logOut = UIImage(named: "logout_button")
            static let mockPhoto = UIImage(named: "ivan_iva")
        }
        
        enum TabBar {
            static let imagesList = UIImage(named: "tab_editorial_active")
            static let profile = UIImage(named: "tab_profile_active")
        }
    }
    
    enum Strings {
        enum Profile {
            static let name = "Ivan Ivanov"
            static let nickname = "@ivanov_iva"
            static let description = "Hello, world!"
        }
    }
}
