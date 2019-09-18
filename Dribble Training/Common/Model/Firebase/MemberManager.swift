//
//  MemberManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import FirebaseAuth

class MemberManager {
    
    static let shared = MemberManager()
    
    private let auth = Auth.auth()
    
    private let firestoreManager = FirestoreManager.shared
    
    var currentUser: Member?
    
    func logIn(withEmail email: String,
               password: String,
               completion: @escaping (Result<String, LogInError>) -> Void) {
        
        auth.signIn(withEmail: email, password: password) {
            
            (authDataResult, error) in
            
            guard
                let uid = authDataResult?.user.uid
                else {
                    if let error = error {
                        print(error)
                    }
                    completion(.failure(.invalidEmailOrPassword))
                    return
            }
            
            self.firestoreManager.fetchMemberData(
                forUID: uid,
                completion: { result in
                
                    switch result {
                        
                    case .success(let member):
                        
                        self.currentUser = member
                        
                        completion(.success("Log In Succeeded"))
                        
                    case .failure(let error):
                        
                        print(error)
                        
                        completion(.failure(.memberDataFetchingError))
                    }
            })
        }
    }
    
    func signUp(withEmail email: String,
                password: String,
                completion: @escaping (Result<String, SignUpError>) -> Void) {
            
        self.auth.createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            guard
                let uid = authDataResult?.user.uid
                else {
                    if let error = error {
                        print(error)
                    }
                    completion(.failure(.accountCreatingFailure))
                    return
            }
            
            let member = Member(uid: uid,
                                id: "default_id",
                                displayName: "",
                                followers: [],
                                followings: [],
                                trainingResults: [],
                                picture: "")
            
            self.firestoreManager.update(member: member)
            
            completion(.success("Sign Up Secceeded"))
        }
    }
    
    enum LogInError: String, Error {
        
        case invalidEmailOrPassword = "Invalid Email or Password"
        
        case memberDataFetchingError = "Member Data Fetching Error"
    }
    
    enum SignUpError: String, Error {
        
        case accountCreatingFailure = "Account Creating Failure"
    }
}
