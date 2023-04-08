//
//  ProfileStruct.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 05.04.2023.
//

import Foundation


struct Profile: Decodable {
    let username: String
    let loginname: String
    let bio: String
    let fullname: String
    
    init(from result: ProfileResult) {
        self.username = result.username
        self.loginname = "@\(result.username)"
        self.bio = result.bio ?? ""
        self.fullname = "\(result.firstname) \(result.lastname)"
    }
    
    
}
