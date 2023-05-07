//
//  Constants.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 18.03.2023.
//

import Foundation

let AccessKey = "1Lb6Q3vvSatZvUHxwByOv8G32vKP_aADyB0S5pqhKzg"
let SecretKey = "Oa7Vc3APhdnv66Dy2seavgdkSXmwDpSITD3bubCD-v4"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"


struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: AccessKey,
            secretKey: SecretKey,
            redirectURI: RedirectURI,
            accessScope: AccessScope,
            defaultBaseURL: DefaultBaseURL,
            authURLString: UnsplashAuthorizeURLString)
    }
    
    
}

//enum UnsplashParam {
//    static let accessKey = "1Lb6Q3vvSatZvUHxwByOv8G32vKP_aADyB0S5pqhKzg"
//    static let secretKey = "Oa7Vc3APhdnv66Dy2seavgdkSXmwDpSITD3bubCD-v4"
//    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
//    static let accessScope = "public+read_user+write_likes"
//    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
//}

enum SegueIdentifier {
    static let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    static let showWebViewSegueIdentifier = "ShowWebView"
}
