//
//  KeychainManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/21.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import KeychainAccess

class KeychainManager {
    
    static let shared = KeychainManager()
    
    private let userToken = "UserToken"
    
    let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    var token: String? {
        
        get { return keychain[userToken] }
        
        set { keychain[userToken] = newValue }
    }
}
