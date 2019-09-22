//
//  TabBarController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/10.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private let tabs: [Tab] = [.postWall, .training, .profile]
    
    private var registerPage: RegisterViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTabBar()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        super.viewDidAppear(animated)
//
////        KeychainManager.shared.uid = nil
//
//        print("tab bar view did appear")
//
//        guard let uid = KeychainManager.shared.uid
//            else {
//
//                setupRegisterPage()
//
//                present(registerPage, animated: false, completion: nil)
//
//                return
//        }
//
//        setup(withUID: uid)
//    }
    
    private func setupRegisterPage() {
        
        let storyboard = UIStoryboard.register
        
        if let registerPage =
            storyboard.instantiateInitialViewController() as? RegisterViewController {
            
            registerPage.loadViewIfNeeded()
            
            self.registerPage = registerPage
        }
    }
    
    private func setup(withUID uid: UID) {
        
        print("setup")
                
        self.fetchUserData(
            for: uid,
            completion: { result in
                
                switch result {
                    
                case .success:
                    
                    self.setupTabBar()
                    
                case .failure(let error):
                    
                    print(error)
                }
        })
    }
    
    private func fetchUserData(for uid: UID,
                               completion: @escaping (Result<String, Error>) -> Void) {
        
        FirestoreManager.shared.fetchMemberData(forUID: uid) { result in
            
            switch result {
                
            case .success(let member):
                
                AuthManager.shared.currentUser = member
                completion(.success("Member Data Fetching Succeeded"))
                
            case .failure(let error):
                
                completion(.failure(error))
            }
        }
    }
    
    private func setupTabBar() {
        
        delegate = self
        
        for tab in tabs {
            
            guard let viewController = tab.controller()
                else {
                    print("Initial View Controller Not Exist")
                    return
            }
            
            addChild(viewController)
        }
    }
    
    private enum Tab {
        
        case postWall
        
        case video
        
        case training
        
        case profile
        
        case team
        
        func controller() -> UIViewController? {
            
            var storyboard: UIStoryboard?
            
            switch self {
                
            case .postWall: storyboard = .postWall
                
            case .video: storyboard = .video
                
            case .training: storyboard = .trainingLobby
                
            case .profile: storyboard = .profile
                
            case .team: storyboard = .team
            }
            
            let controller = storyboard?.instantiateInitialViewController()
            
            controller?.tabBarItem = tabBarItem()
            
            return controller
        }
        
        private func tabBarItem() -> UITabBarItem {
            
            var imageAsset: UIImage.Asset
            
            switch self {
                
            case .postWall: imageAsset = .post
                
            case .video: imageAsset = .video
                
            case .training: imageAsset = .training
                
            case .profile: imageAsset = .profile
                
            case .team: imageAsset = .team
            }
            
            let tabBarItem = UITabBarItem()
            
            tabBarItem.image = UIImage.asset(imageAsset)
            
            tabBarItem.title = imageAsset.rawValue
            
            return tabBarItem
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        
        if
            let navigationController = viewController as? UINavigationController,
            let profileViewController = navigationController.viewControllers.first as? ProfileViewController {
            
            profileViewController.member = AuthManager.shared.currentUser
        }
    }
}
