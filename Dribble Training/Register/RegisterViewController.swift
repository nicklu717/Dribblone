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
    
    let authManager = AuthManager.shared
    
    func logIn(withEmail email: String, password: String) {
        
        authManager.logIn(withEmail: email, password: password) { result in
            
            switch result {
                
            case .success(let message):
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                
                // TODO: Show Success Alert
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.registerView.showErrorMessage(error.rawValue)
                }
            }
        }
    }
    
    func signUp(withEmail email: String, password: String) {
        
        authManager.signUp(withEmail: email, password: password) { result in
                
            switch result {
                
            case .success(let message):
                
                DispatchQueue.main.async {
                    self.registerView.switchStatus()
                }
                
                // TODO: Show Success Alert
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.registerView.showErrorMessage(error.rawValue)
                }
            }
        }
    }
}
