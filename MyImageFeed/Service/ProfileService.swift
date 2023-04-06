//
//  ProfileService.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 05.04.2023.
//

import Foundation


final class ProfileService {
    private static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var profile: Profile?
    
    private let token = OAuth2TokenStorage().token
    
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            return
        }
        
        var request = URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: URL(string: "https://unsplash.com")!
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    }
}


