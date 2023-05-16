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
    private var likeTask: URLSessionTask?
    private let dateFormatter = ISO8601DateFormatter()
    
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
        
        guard let lastLoadedPage = lastLoadedPage else { return }
        guard let token = OAuth2TokenStorage().token else { return }
        
        var request = URLRequest.makeHTTPRequest(path: "/photos" + "/?page=\(lastLoadedPage)", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            self.task = nil
            switch result {
            case .success(let responseBody):
                responseBody.forEach { [weak self] photoResult in
                    guard let self = self else { return }
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
        self.task = task
        task.resume()
    }
    
    
    func changeLike(photosId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        if likeTask != nil {
            return
        }
        
        let method = isLiked ? "POST" : "DELETE"
        guard let token = OAuth2TokenStorage().token else { return }
        
        var request = URLRequest.makeHTTPRequest(path: "/photos" + "/\(photosId)" + "/like", httpMethod: method)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self = self else { return }
            
            self.likeTask = nil
            switch result{
            case .success(let responsePhoto):
                let newPhoto = LikeResult(likedPhotoResult: responsePhoto)
                if let index = self.photos.firstIndex(where: { $0.id == photosId }) {
                   var photo = self.photos[index]
                    photo.isLiked = newPhoto.likePhoto.liked_by_user
                    self.photos[index] = photo
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.likeTask = task
        task.resume()
    }
}
