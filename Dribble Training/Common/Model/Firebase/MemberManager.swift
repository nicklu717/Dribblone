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
    
    var currentUser: Member?
    
    func logIn(withEmail: String, password: String) {}
    
    func signUp(withEmail: String, password: String, id: String) {}
    
    func fetchMemberData(forID id: String) {}
}
