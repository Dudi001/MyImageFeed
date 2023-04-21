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
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
    
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil {
            return
        }
        
        if lastLoadedPage == nil {
            lastLoadedPage = 1
        } else {
            lastLoadedPage! += 1
        }
        
        guard let token = OAuth2TokenStorage().token else { return }
        
        var request = URLRequest.makeHTTPRequest(path: "/photos" + "/?page=\(lastLoadedPage!)", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseBody):
                responseBody.forEach { photoResult in

                    guard let date = photoResult.created_at else { return }
//                    print(date)
//                    print(self.dateFormatter.string(from: .now))
                    self.photos.append(Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: self.dateFormatter.date(from: photoResult.created_at ?? ""),
                        welcomeDescription: photoResult.description ?? "",
                        thumbImageURL: photoResult.urls.thumb ?? "",
                        largeImageURL: photoResult.urls.full ?? "",
                        isLiked: photoResult.liked_by_user))
                }

                NotificationCenter.default.post(
                    name: ImagesListService.DidChangeNotification,
                    object: self,
                    userInfo: ["Photos": self.photos])
            case .failure(let error):
                print("PHOTO REQUEST ERROR: \(error)")
            }
        }
        task.resume()
    }
    
    
    func changeLike(photosId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let method = isLiked ? "POST" : "DELETE"
        guard let token = OAuth2TokenStorage().token else { return }
        
        var request = URLRequest.makeHTTPRequest(path: "/photos" + "/\(photosId)" + "/like", httpMethod: method)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    
}
