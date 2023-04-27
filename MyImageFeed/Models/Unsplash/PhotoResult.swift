//
//  PhotoResult.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 17.04.2023.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let created_at: String?
    let width: Int
    let height: Int
    let liked_by_user: Bool
    let description: String?
    let urls: Urls
    
    enum CodingKeys: String, CodingKey {
        case id
        case created_at
        case width
        case height
        case liked_by_user
        case description
        case urls
    }

}

struct Urls: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

struct LikePhotoResult:Decodable {
    let photo: PhotoResult
}
