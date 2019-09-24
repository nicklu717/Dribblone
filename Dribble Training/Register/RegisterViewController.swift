//
//  RegisterViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, RegisterViewDelegate {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - Property Declaration
    
    @IBOutlet var registerView: RegisterView! {
        didSet {
            registerView.delegate = self
        }
    }
    
    // MARK: - Instance Method
    
    func signUp(withEmail email: String, password: String, confirmPassword: String, id: ID) {
        
        if hasBlank() { return }
        
        if !isPasswordConfirmed() {
            
            showErrorMessage(.passwordNotConfirmed)
            return
        }
        
        AuthManager.shared.signUp(
            withEmail: email,
            password: password) { result in
                
                switch result {
                    
                case .success(let uid):
                    
                    let member = Member(uid: uid,
                                        id: "default_id",
                                        displayName: "",
                                        followers: [],
                                        followings: [],
                                        blockList: [],
                                        trainingResults: [],
                                        picture: "")
                    
                    FirestoreManager.shared.update(
                        member: member,
                        completion: {
                            
                            // Show success alert
                            self.registerView.switchStatus()
                    })
                    
                case .failure(let error):
                    
                    self.showErrorMessage(.signUpFail)
                    print(error)
                }
        }
    }
    
    func logIn(withEmail email: String, password: String) {
        
        AuthManager.shared.logIn(
            withEmail: email,
            password: password) { result in
                
                switch result {
                    
                case .success(let uid):
                    
                    KeychainManager.shared.uid = uid
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    
                    self.showErrorMessage(.logInFail)
                    print(error)
                }
        }
    }
    
    private func hasBlank() -> Bool {
        
        var hasBlank: Bool = false
        
        var textFields = [UITextField]()
        
        switch registerView.status {
            
        case .logIn:
            
            textFields = [registerView.emailTextField,
                          registerView.passwordTextField]
            
        case .signUp:
            
            textFields = [registerView.emailTextField,
                          registerView.passwordTextField,
                          registerView.confirmPasswordTextField,
                          registerView.idTextField]
        }
        
        for textField in textFields where textField.text == "" {
            
            let red = UIColor.red.withAlphaComponent(0.3)
            
            textField.flashBackground(with: red, duration: 0.15)
            
            hasBlank = true
        }
        
        return hasBlank
    }
    
    private func isPasswordConfirmed() -> Bool {
        
        var confirmed: Bool = true
        
        switch registerView.status {
            
        case .logIn: break
            
        case .signUp:
            
            confirmed =
                (registerView.passwordTextField.text == registerView.confirmPasswordTextField.text)
        }
        
        return confirmed
    }
    
    private func showErrorMessage(_ message: RegisterError) {
        
        registerView.errorMessageLabel.text = message.rawValue
        
        registerView.errorMessageLabel.isHidden = false
    }
    
    private enum RegisterError: String {
        
        case passwordNotConfirmed = "Password Not Confirmed"
        
        case signUpFail = "Sign Up Failure"
        
        case logInFail = "Log In Failure"
    }
}
