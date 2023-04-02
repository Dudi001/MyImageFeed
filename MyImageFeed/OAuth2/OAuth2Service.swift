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
        completion: @escaping (Result<String, Error>) -> Void) {
            
            let mainThread: (Result<String, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            let request = authTokenRequest(code: code)
            
            urlSession.dataTask(
                with: request) {data, response, error in
                    guard
                        let data = data,
                        let response = response as? HTTPURLResponse,
                        response.statusCode > 200 || response.statusCode <= 300
                    else {
                        return assertionFailure("url response status code within (200, 300]: \(#function), line: \(#line)")
                    }
                    
                    do {
                        let responseBody = try JSONDecoder().decode(
                            OAuthTokenResponseBody.self,
                            from: data)
                        OAuth2TokenStorage().token = responseBody.accessToken
                        print("THIS IS TOKEN \(responseBody.accessToken)")
                        mainThread(.success(responseBody.accessToken))
                    } catch {
                        mainThread(.failure(error))
                    }
                }.resume()
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
