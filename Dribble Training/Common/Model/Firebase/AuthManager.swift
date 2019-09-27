//
//  AuthManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import FirebaseAuth

class AuthManager {
    
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    var currentUser: Member!
    
    func signUp(withEmail email: String,
                password: String,
                completion: @escaping (Result<UID, Error>) -> Void) {
        
        auth.createUser(
            withEmail: email,
            password: password) { (authDataResult, error) in
                
                if let error = error {
                    
                    completion(.failure(error))
                }
                
                if let authDataResult = authDataResult {
                    
                    completion(.success(authDataResult.user.uid))
                }
        }
    }
    
    func logIn(withEmail email: String,
               password: String,
               completion: @escaping (Result<UID, Error>) -> Void) {
        
        auth.signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if let error = error {
                
                completion(.failure(error))
            }
            
            if let authDataResult = authDataResult {
                
                completion(.success(authDataResult.user.uid))
            }
        }
    }
}
