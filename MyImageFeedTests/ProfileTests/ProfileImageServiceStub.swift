//
//  ProfileImageServiceStub.swift
//  MyImageFeedTests
//
//  Created by Мурад Манапов on 14.05.2023.
//

import UIKit
import Kingfisher
@testable import MyImageFeed


final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    var avatarURL: String?
    var avatarImage = UIImageView()
    
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
    }
    
    func setImage(avatarUrl: String){
        guard let url = URL(string: avatarUrl) else { return }
        avatarImage.kf.setImage(with: url)
    }
    
}
