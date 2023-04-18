//
//  ImagesListService.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 17.04.2023.
//

import Foundation


final class ImagesListService {
    static let shared = ImagesListService()
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var task: URLSessionTask?
    
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil {
            return
        }
        
        let nextPage = lastLoadedPage == nil
            ? 1
            : lastLoadedPage! + 1
        
        guard let token = OAuth2TokenStorage().token else { return }
        
        var request = URLRequest.makeHTTPRequest(path: "photos/?page=\(lastLoadedPage!)", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseBody):
                responseBody.forEach { photoResult in
                    self.photos.append(Photo(from: photoResult))
                }
                NotificationCenter.default.post(
                    name: ImagesListService.DidChangeNotification,
                    object: self,
                    userInfo: ["Photos": self.photos])
                
            case .failure(let error):
                print("PHOTO REQUEST ERROR: \(error)")
            }
        }
    }
}
