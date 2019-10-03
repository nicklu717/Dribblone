//
//  RegisterViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import AuthenticationServices

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
    
    var logInCompletion: (() -> Void)?
    
    // MARK: - Life Cycle
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        setupAppleSignInButton()
    }
    
    // MARK: - Instance Method
    
    func signUp(withEmail email: String, password: String, confirmPassword: String, id: ID) {
        
        if hasBlank() { return }
        
        if !isPasswordConfirmed() {
            
            showErrorMessage(.passwordNotConfirmed)
            return
        }
        
        FirestoreManager.shared.checkAvailable(for: id) { isAvailable in
            
            if isAvailable {
                
                AuthManager.shared.signUp(
                    withEmail: email,
                    password: password) { result in
                        
                        switch result {
                            
                        case .success(let uid):
                            
                            let member = Member(uid: uid,
                                                id: id,
                                                displayName: "",
                                                followers: [],
                                                followings: [],
                                                blockList: [],
                                                trainingResults: [],
                                                picture: "",
                                                teams: [],
                                                teamInvitations: [],
                                                blockTeamList: [])
                            
                            FirestoreManager.shared.create(
                                member: member,
                                completion: {
                                    
                                    // Show success alert
                                    self.registerView.switchStatus()
                                    self.registerView.logIn()
                            })
                            
                        case .failure(let error):
                            
                            self.showErrorMessage(.signUpFail)
                            print(error)
                        }
                }
                
            } else {
                
                self.showErrorMessage(.idNotAvailable)
            }
        }
    }
    
    func logIn(withEmail email: String, password: String) {
        
        if hasBlank() { return }
        
        AuthManager.shared.logIn(
            withEmail: email,
            password: password) { result in
                
                switch result {
                    
                case .success(let uid):
                    
                    self.logInSuccess(uid: uid)
                    
                case .failure(let error):
                    
                    self.showErrorMessage(.logInFail)
                    
                    print(error)
                }
        }
    }
    
    func showPrivacyPolicy() {
        
        show(PrivacyViewController(), sender: nil)
    }
    
    @objc func appleSignInHandler() {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()

        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])

        authorizationController.delegate = self

        authorizationController.performRequests()
    }
    
    // MARK: - Private Method
    
    private func setupAppleSignInButton() {
        
        let appleSignInButton = ASAuthorizationAppleIDButton()

        appleSignInButton.addTarget(self, action: #selector(appleSignInHandler), for: .touchUpInside)
        
        appleSignInButton.removeConstraints(appleSignInButton.constraints)
        
        appleSignInButton.frame = registerView.appleSignInView.bounds

        registerView.appleSignInView.addSubview(appleSignInButton)
    }
    
    private func logInSuccess(uid: UID) {
        
        KeychainManager.shared.uid = uid
        
        logInCompletion?()
    }
    
    private func hasBlank() -> Bool {
        
        var hasBlank: Bool = false
        
        var textFields: [UITextField] = []
        
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
            
            let red = UIColor.brown2.withAlphaComponent(0.6)
            
            textField.flashBackground(with: red, duration: 0.15)
            
            hasBlank = true
        }
        
        return hasBlank
    }
    
    private func isPasswordConfirmed() -> Bool {
        
        return (registerView.passwordTextField.text == registerView.confirmPasswordTextField.text)
    }
    
    private func showErrorMessage(_ message: RegisterError) {
        
        registerView.errorMessageLabel.text = message.rawValue
        
        registerView.errorMessageLabel.isHidden = false
    }
    
    private enum RegisterError: String {
        
        case passwordNotConfirmed = "Password Not Confirmed"
        
        case idNotAvailable = "ID Not Available"
        
        case signUpFail = "Sign Up Failure"
        
        case logInFail = "Log In Failure"
    }
}

extension RegisterViewController: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let uid = credential.user
            
            FirestoreManager.shared.fetchMemberData(forUID: uid) { result in
                
                switch result {
                    
                case .success(let member):
                    
                    if let member = member {
                        
                        self.logInSuccess(uid: member.uid)
                        
                        return
                    }
                    
                    let userName = credential.fullName?.nickname ?? ""
                    
                    var id = ""
                    
                    if let email = credential.email {
                        
                        let firstAT = email.firstIndex(of: "@") ?? email.endIndex
                        
                        id = email[..<firstAT].description
                        
                    } else {
                        
                        let firstDot = uid.firstIndex(of: ".") ?? uid.startIndex
                        let lastDot = uid.lastIndex(of: ".") ?? uid.endIndex
                        
                        id = uid[firstDot..<lastDot].dropFirst(1).description
                    }
                    
                    let member = Member(uid: uid,
                                        id: id,
                                        displayName: userName,
                                        followers: [],
                                        followings: [],
                                        blockList: [],
                                        trainingResults: [],
                                        picture: "",
                                        teams: [],
                                        teamInvitations: [],
                                        blockTeamList: [])
                    
                    FirestoreManager.shared.create(member: member, completion: {
                        
                        self.logInSuccess(uid: member.uid)
                    })
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print(error)
    }
}
