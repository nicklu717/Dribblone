//
//  RegisterView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol RegisterViewDelegate: UIViewController {
    
    func signUp(withEmail email: String, password: String, confirmPassword: String, id: ID)
    
    func logIn(withEmail email: String, password: String)
}

class RegisterView: UIView {
    
    weak var delegate: RegisterViewDelegate?
    
    @IBOutlet var errorMessageLabel: UILabel!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var idTextField: UITextField!
    
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var switchStatusButton: UIButton!
    
    var status: Status = .logIn
    
    @IBAction func logIn() {
        
        errorMessageLabel.isHidden = true
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        let id: ID = idTextField.text ?? ""
        
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
            
            confirmPasswordTextField.isHidden = false
            
            idTextField.isHidden = false
            
            logInButton.setTitle("Sign Up", for: .normal)
            
            switchStatusButton.setTitle("Log In?", for: .normal)
            
        case .signUp:
            
            status = .logIn
            
            confirmPasswordTextField.isHidden = true
            confirmPasswordTextField.text = ""
            
            idTextField.isHidden = true
            idTextField.text = ""
            
            logInButton.setTitle("Log In", for: .normal)
            
            switchStatusButton.setTitle("Create an account", for: .normal)
        }
    }
    
    enum Status {
        
        case logIn
        
        case signUp
    }
}
