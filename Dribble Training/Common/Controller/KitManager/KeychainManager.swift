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
    
    private let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    var uid: String? {
        
        get { return keychain[KeyName.userUID] }
        
        set { keychain[KeyName.userUID] = newValue }
    }
    
    private struct KeyName {
        
        static let userUID = "user_uid"
    }
}
