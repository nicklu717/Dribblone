//
//  AuthManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import FirebaseAuth

typealias UID = String
typealias Token = String

class AuthManager {
    
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    var currentUser: Member!
    
    func signUp(withEmail email: String,
                password: String,
                completion: @escaping (Result<Token, Error>) -> Void) {
        
        auth.createUser(
            withEmail: email,
            password: password) { (authDataResult, error) in
                
                if let error = error {
                    completion(.failure(error))
                }
                
                if let authDataResult = authDataResult {
                    
                    authDataResult.user.getIDToken(completion: { (token, error) in
                        
                        if let error = error {
                            completion(.failure(error))
                        }
                        
                        if let token = token {
                            completion(.success(token))
                        }
                    })
                }
        }
    }
    
    func logIn(completion: @escaping (Result<UID, Error>) -> Void) {
        
        guard let token = KeychainManager.shared.token
            else {
                print("User Token Not Exist")
                return
        }
        
        auth.signIn(withCustomToken: token) { (authDataResult, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            
            if let authDataResult = authDataResult {
                completion(.success(authDataResult.user.uid))
            }
        }
    }
}
