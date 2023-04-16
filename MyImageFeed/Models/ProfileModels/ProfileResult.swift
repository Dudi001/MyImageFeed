//
//  ProfileResult.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 05.04.2023.
//

import Foundation


struct ProfileResult: Codable {
    let username: String
    let firstname: String
    let lastname: String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstname = "first_name"
        case lastname = "last_name"
        case bio = "bio"
    }
}
