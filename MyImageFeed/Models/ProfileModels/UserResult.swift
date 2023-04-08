//
//  UserResult.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 07.04.2023.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImage
    
    struct ProfileImage: Decodable {
        let small: String
    }
}
