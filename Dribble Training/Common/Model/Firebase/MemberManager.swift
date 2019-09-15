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
    
    private let databaseManager = DatabaseManager.shared
    
    var currentUser: Member?
    
    func logIn(withEmail email: String, password: String) {
        
        auth.signIn(withEmail: email,
                    password: password) { (authDataResult, error) in
            
            guard
                let uid = authDataResult?.user.uid
                else {
                    if let error = error {
                        print(error)
                    }
                    return
            }
            
            self.databaseManager.fetchMemberData(
                forUID: uid,
                completion: { result in
                
                    switch result {
                        
                    case .success(let member):
                        
                        self.currentUser = member
                        
                    case .failure(let error):
                        
                        print(error)
                    }
            })
        }
    }
    
    func signUp(withEmail email: String, password: String, id: String) {}
}
