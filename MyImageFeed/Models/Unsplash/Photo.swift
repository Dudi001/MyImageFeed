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
    let isLiked: Bool
    
    init(from result: PhotoResult) {
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        self.createdAt = DateFormatter().date(from: result.created_at)
        self.welcomeDescription = result.description ?? ""
        self.thumbImageURL = result.urls.thumb
        self.largeImageURL = result.urls.full
        self.isLiked = false
    }
}
