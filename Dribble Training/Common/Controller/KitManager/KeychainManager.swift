//
//  KeychainManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/21.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import KeychainAccess

class KeychainManager {
    
    static let `default` = KeychainManager(keychain: Keychain(service: Bundle.main.bundleIdentifier!))
    
    private let keychain: Keychain
    
    init(keychain: Keychain) {
        self.keychain = keychain
    }
    
    var userUID: String? {
        get { keychain[.userUID] }
        set { keychain[.userUID] = newValue }
    }
}

private extension KeychainManager {
    
    enum Key: String {
        case userUID = "userUID"
    }
}

private extension Keychain {
    
    subscript(key: KeychainManager.Key) -> String? {
        get { self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }
}
