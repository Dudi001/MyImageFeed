//
//  Constants.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 18.03.2023.
//

import Foundation

enum UnsplashParam {
    static let accessKey = "1Lb6Q3vvSatZvUHxwByOv8G32vKP_aADyB0S5pqhKzg"
    static let secretKey = "Oa7Vc3APhdnv66Dy2seavgdkSXmwDpSITD3bubCD-v4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}

enum SegueIdentifier {
    static let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    static let showWebViewSegueIdentifier = "ShowWebView"
}
