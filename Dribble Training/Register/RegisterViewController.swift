//
//  RegisterViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, RegisterViewDelegate {
    
    @IBOutlet var registerView: RegisterView! {
        didSet {
            registerView.delegate = self
        }
    }
    
    let memberManager = MemberManager.shared
    
    func logIn(withEmail email: String, password: String) {
        
        memberManager.logIn(withEmail: email, password: password)
    }
    
    func signUp(withEmail email: String, password: String, id: String) {
        
        memberManager.SignUp(withEmail: email, password: password, id: id)
    }
}
