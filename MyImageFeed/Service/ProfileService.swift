//
//  ProfileService.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 05.04.2023.
//ce1cUqEUGwjn7sJXSgE-BYIjGXRgyuLPYScvK6JmKuc
//ce1cUqEUGwjn7sJXSgE-BYIjGXRgyuLPYScvK6JmKuc

import Foundation


final class ProfileService {
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var profile: Profile?
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            return
        }
        
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        
        let task = urlSession.objectTask(for: request) {
            [weak self] (result: Result<ProfileResult, Error>) in

            guard let self = self else { return }
            
            switch result {
            case .success(let responseBody):
                self.profile = Profile(from: responseBody)
                guard let profile = self.profile else { return }
                UIBlockingProgressHUD.dismiss()
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()

    }
}


