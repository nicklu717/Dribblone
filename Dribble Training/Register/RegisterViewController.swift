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
    
    func signUp(withEmail email: String, password: String) {
        
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
                    
                    self.registerView.showErrorMessage("Sign Up Failure!")
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
                    
                    self.registerView.showErrorMessage("Log In Failure!")
                    print(error)
                }
        }
    }
}
