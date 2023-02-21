//
//  MainViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/22.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - Property Declaration
    private var registerPage: RegisterViewController!
    
    // MARK: - Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUID()
    }
    
    func checkUID() {
        dismiss(animated: true, completion: nil)
        guard let userUID = KeychainManager.default.userUID else {
            setupRegisterPage()
            present(registerPage, animated: false, completion: nil)
            return
        }
        welcomeUser(withUID: userUID)
    }
    
    // MARK: - Private Method
    private func welcomeUser(withUID uid: UID) {
        fetchUserData(for: uid) {
            let tabBarController = TabBarController()
            tabBarController.modalPresentationStyle = .overFullScreen
            self.present(tabBarController, animated: false, completion: nil)
        }
    }
    
    private func setupRegisterPage() {
        let viewController = UIStoryboard.register.instantiateInitialViewController()
        guard let registerPage = viewController as? RegisterViewController else { return }
        registerPage.logInCompletion = checkUID
        self.registerPage = registerPage
    }
    
    private func fetchUserData(for uid: UID, completion: (() -> Void)?) {
        FirestoreManager.default.fetchMemberData(forUID: uid) { (result) in
            switch result {
            case .success(let member):
                AuthManager.default.currentUser = member
            case .failure(let error):
                print(error)
            }
            completion?()
        }
    }
}
