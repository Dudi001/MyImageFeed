//
//  NetWork.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 25.03.2023.
//

import Foundation


typealias OAuthTokenResponseResult = Result<OAuthTokenResponseBody, Error>
typealias OAuthTokenResponseHandler = (OAuthTokenResponseResult) -> Void


final class OAuth2Service {
    
    
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private var lastCode: String?
    private var task: URLSessionTask?
    
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(UnsplashParam.accessKey)"
            + "&&client_secret=\(UnsplashParam.secretKey)"
            + "&&redirect_uri=\(UnsplashParam.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
    
    private func completeOnMainThread(
        handler: @escaping OAuthTokenResponseHandler,
        with arg: OAuthTokenResponseResult
    ) {
        DispatchQueue.main.async {
            handler(arg)
        }
    }
    
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping OAuthTokenResponseHandler ) {
            
            assert(Thread.isMainThread)
            if lastCode == code { return }
            task?.cancel()
            lastCode = code
            
            
            let request = authTokenRequest(code: code)
            
            let task = urlSession.objectTask(for: request) { (result: OAuthTokenResponseResult) in
                switch result {
                case.success(let responseBody):
                    OAuth2TokenStorage().token = responseBody.accessToken
                    completion(.success(responseBody))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.lastCode = nil
                }
            }
            self.task = task
            task.resume()
        }
    
}
    // MARK: - HTTP Request
extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = UnsplashParam.defaultBaseURL
    ) -> URLRequest {
            
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}
