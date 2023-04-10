//
//  OAuth2Service.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 27.03.2023.
//

import Foundation
import SwiftKeychainWrapper


class OAuth2TokenStorage {
    private let Keychain = KeychainWrapper.standard
    private let bearerToken = "bearer"
    
    var token: String? {
        get {
            return Keychain.string(forKey: bearerToken)
        }
        set {
            guard let data = newValue else { return }
            Keychain.set(data, forKey: bearerToken)
        }
    }
}



