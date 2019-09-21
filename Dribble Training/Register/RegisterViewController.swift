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
    
    var completion: (() -> Void)?
    
    func signUp(withEmail email: String, password: String) {
        
        AuthManager.shared.signUp(
            withEmail: email,
            password: password) { result in
                
                switch result {
                    
                case .success(let token):
                    
                    KeychainManager.shared.token = token
                    
                case .failure(let error):
                    
                    self.registerView.showErrorMessage("Sign Up Failure!")
                    print(error)
                }
                
                self.completion?()
        }
    }
}
