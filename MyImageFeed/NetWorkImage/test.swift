//
//  test.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 25.03.2023.
//

import Foundation





typealias OAuthTokenResponseHandler = (Result<OAuthTokenResponseBody, Error>) -> Void

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private let urlSession: URLSession = URLSession.shared
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    

    //1 Структура запроса для получения токена
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
        with arg: Result<OAuthTokenResponseBody, Error>
    ) {
        DispatchQueue.main.async {
            handler(arg)
        }
    }
    

    func fetchOAuthToken(
        _ code: String,
        completion: @escaping OAuthTokenResponseHandler
    ){
        
        let request = authTokenRequest(code: code)
        
        urlSession.dataTask(
            with: request,
            completionHandler: { [weak self] data, response, error in
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode > 200 || response.statusCode <= 300 else { return }
                do {
                    let bodyToken = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    
                    self?.completeOnMainThread(
                        handler: completion,
                        with: .success(bodyToken)
                    )
                    print(bodyToken)
                } catch {
                    self?.completeOnMainThread(
                        handler: completion,
                        with: .failure(error)
                    )
                }
        }).resume()
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


