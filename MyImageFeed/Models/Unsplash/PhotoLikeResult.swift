//
//  PhotoLikeResult.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 21.04.2023.
//

import Foundation


struct PhotoLikeResult: Codable {
    let photo: PhotoItem
}

struct PhotoItem: Codable {
    let id: String
    let liked_by_user: Bool
}
