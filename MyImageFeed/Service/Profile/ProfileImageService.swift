//
//  ProfileImageService.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 07.04.2023.
//

import Foundation


protocol ProfileImageServiceProtocol: AnyObject {
    var avatarURL: String? { get set }
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void)
}


final class ProfileImageService {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            return
        }
        
        guard let token  = OAuth2TokenStorage().token else {
            return assertionFailure("Problem with token")
        }

        
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        
        let task = urlSession.objectTask(for: request) {
            [weak self] (result: Result<UserResult, Error>) in

            guard let self = self else { return }
            switch result {
            case .success(let responseBody):
                let smalImage = responseBody.profileImage.medium
                self.avatarURL = smalImage
                completion(.success(self.avatarURL!))
                NotificationCenter.default.post(
                    name: ProfileImageService.DidChangeNotification,
                    object: self,
                    userInfo: ["URL": smalImage]
                )
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()

    }
}
