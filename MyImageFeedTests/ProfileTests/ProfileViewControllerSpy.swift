//
//  ProfileViewControllerSpy.swift
//  MyImageFeedTests
//
//  Created by Мурад Манапов on 14.05.2023.
//

import Foundation
@testable import MyImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: MyImageFeed.ProfileViewPresenterProtocol?
    var didUpdate: Bool = false
    let imageService = ProfileImageServiceStub()
    var avatarURL = "https://kafel.ee/wp-content/uploads/2019/02/013-duck.png"
    
    func updateAvatar() {
        imageService.setImage(avatarUrl: avatarURL)
    }
    
    
}
