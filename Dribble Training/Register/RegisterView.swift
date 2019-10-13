//
//  RegisterView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol RegisterViewDelegate: AnyObject {
    
    func signUp(withEmail email: String, password: String, confirmPassword: String, id: ID)
    
    func logIn(withEmail email: String, password: String)
    
    func showPrivacyPolicy()
}

class RegisterView: UIView {
    
    // MARK: - Property Declaration
    
    weak var delegate: RegisterViewDelegate?
    
    @IBOutlet var errorMessageLabel: UILabel!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    @IBOutlet var idTextField: UITextField!
    
    @IBOutlet var logInButton: UIButton!
    
    @IBOutlet var appleSignInView: UIView!
    
    @IBOutlet var switchStatusButton: UIButton!
    
    var status: Status = .logIn
    
    enum Status {
        
        case logIn
        
        case signUp
    }
    
    // MARK: - Instance Method
    
    @IBAction func logIn() {
        
        errorMessageLabel.isHidden = true
        
        let email = emailTextField.text ?? .empty
        
        let password = passwordTextField.text ?? .empty
        
        let confirmPassword = confirmPasswordTextField.text ?? .empty
        
        let id: ID = idTextField.text ?? .empty
        
        switch status {
        
        case .logIn:
            
            delegate?.logIn(withEmail: email, password: password)
        
        case .signUp:
            
            delegate?.signUp(withEmail: email,
                             password: password,
                             confirmPassword: confirmPassword,
                             id: id)
        }
    }
    
    @IBAction func switchStatus() {
        
        errorMessageLabel.isHidden = true
        
        switch status {
            
        case .logIn:
            
            status = .signUp
            
            confirmPasswordTextField.text = .empty
            
            idTextField.text = .empty
            
            UIView.animate(withDuration: 0.2) {
                
                self.confirmPasswordTextField.alpha = 1
                
                self.idTextField.alpha = 1
            }
            
            logInButton.setTitle("Sign Up", for: .normal)
            
            switchStatusButton.setTitle("Log in?", for: .normal)
            
        case .signUp:
            
            status = .logIn
            
            UIView.animate(withDuration: 0.2) {
                
                self.confirmPasswordTextField.alpha = 0
                
                self.idTextField.alpha = 0
            }
            
            logInButton.setTitle("  Log In  ", for: .normal)
            
            switchStatusButton.setTitle("Create account", for: .normal)
        }
    }
    
    @IBAction func showPrivacyPolicy() {
        
        delegate?.showPrivacyPolicy()
    }
}
