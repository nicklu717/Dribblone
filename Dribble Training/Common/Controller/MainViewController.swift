//
//  MainViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/22.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private var registerPage: RegisterViewController!
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
//        KeychainManager.shared.uid = nil
        
        guard let uid = KeychainManager.shared.uid
            else {
                
                setupRegisterPage()
                
                present(registerPage, animated: false, completion: nil)
                
                return
        }
        
        fetchUserData(for: uid) {
            
            self.present(TabBarController(), animated: false, completion: nil)
        }
    }
    
    private func setupRegisterPage() {
        
        let storyboard = UIStoryboard.register
        
        if let registerPage =
            storyboard.instantiateInitialViewController() as? RegisterViewController {
            
            self.registerPage = registerPage
        }
    }
    
    private func fetchUserData(for uid: UID,
                               completion: (() -> Void)?) {
        
        FirestoreManager.shared.fetchMemberData(forUID: uid) { result in
            
            switch result {
                
            case .success(let member):
                
                AuthManager.shared.currentUser = member
                
            case .failure(let error):
                
                print(error)
            }
            
            completion?()
        }
    }
}
