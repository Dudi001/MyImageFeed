//
//  OAuth2Service.swift
//  MyImageFeed
//
//  Created by Мурад Манапов on 27.03.2023.
//

import Foundation


final class OAuth2TokenStorage {
    
    private var authToken: String = ""

    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: authToken)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: authToken)
        }
    }

    func deleteToken() {
        UserDefaults.standard.removeObject(forKey: authToken)
        }
}
