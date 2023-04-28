//
//  Photo.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 17.04.2023.
//

import Foundation


struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
}

struct LikeResult {
    let likePhoto: PhotoResult
    
    init(likedPhotoResult: LikePhotoResult) {
        self.likePhoto = likedPhotoResult.photo
    }
}
