//
//  RegisterView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol RegisterViewDelegate: UIViewController {
    
    func logIn(withEmail email: String, password: String)
    
    func signUp(withEmail email: String, password: String)
}

class RegisterView: UIView {
    
    weak var delegate: RegisterViewDelegate?
    
    @IBOutlet var errorMessageLabel: UILabel!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var idTextField: UITextField!

    @IBOutlet var logInView: UIView!
    @IBOutlet var signUpView: UIView!
    
    @IBAction func dismiss() {
        delegate?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logIn() {
        
        errorMessageLabel.isHidden = true
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        delegate?.logIn(withEmail: email, password: password)
    }
    
    @IBAction func signUp() {
        
        errorMessageLabel.isHidden = true
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        delegate?.signUp(withEmail: email, password: password)
    }
    
    @IBAction func switchStatus() {
        
        errorMessageLabel.isHidden = true
        
        logInView.isHidden = !logInView.isHidden
        
        signUpView.isHidden = !signUpView.isHidden
    }
    
    func showErrorMessage(_ message: String) {
        
        errorMessageLabel.text = message
        
        errorMessageLabel.isHidden = false
    }
}
