//
//  ProfileStruct.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 05.04.2023.
//

import Foundation


struct Profile: Decodable {
    let username: String
    let firstname: String
    let lastname: String
    let loginname: String
    let bio: String
    let fullname: String
    
    init(username: String, firstname: String, lastname: String, bio: String) {
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.loginname = "@\(username)"
        self.bio = bio
        self.fullname = "\(firstname) \(lastname)"
    }
    
    
}
