//
//  LogInView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class LogInView: UIView {
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var idTextField: UITextField!
    
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var switchToSignUpButton: UIButton!
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var switchToLogInButton: UIButton!
    
    var isLogIn: Bool = true

    @IBAction func logIn() {
    }
    
    @IBAction func signUp() {
    }
    
    @IBAction func switchStatus() {
    }
}
