//
//  NetWork.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 25.03.2023.
//

import Foundation



// MARK: - Network Connection
enum NetworkError: Error {
    case httpStatusCode
    case urlRequestError(Error)
    case urlSessionError
}


extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                fulfillCompletion(.failure(NetworkError.httpStatusCode))
                return
            }
            
            guard let data = data else { return }
            fulfillCompletion(.success(data))
        })
        task.resume()
        return task
        
    }
}

