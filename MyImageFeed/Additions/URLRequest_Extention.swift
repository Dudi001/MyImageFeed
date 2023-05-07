//
//  URLRequest_Extention.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 08.04.2023.
//

import Foundation


extension URLRequest {
static func makeHTTPRequest(
    path: String,
    httpMethod: String,
    baseURL: URL = AuthConfiguration.standard.defaultBaseURL
) -> URLRequest {
        
    var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
    request.httpMethod = httpMethod
    return request
}
}
