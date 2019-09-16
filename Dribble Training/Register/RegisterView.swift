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
    
    func signUp(withEmail email: String, password: String, id: String)
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
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        delegate?.logIn(withEmail: email, password: password)
    }
    
    @IBAction func signUp() {
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let id = idTextField.text ?? ""
        
        delegate?.signUp(withEmail: email, password: password, id: id)
    }
    
    @IBAction func switchStatus() {
        
        logInView.isHidden = !logInView.isHidden
        
        signUpView.isHidden = !signUpView.isHidden
    }
}
