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
    
    // MARK: - Property Declaration
    
    private let tabs: [Tab] = [.postWall, .training, .profile]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    // MARK: - Private Method
    
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
        
        tabBar.isTranslucent = false
        
        tabBar.tintColor = .brown3
    }
    
    private enum Tab {
        
        case postWall
        
        case training
        
        case profile
        
        func controller() -> UIViewController? {
            
            var storyboard: UIStoryboard?
            
            switch self {
                
            case .postWall: storyboard = .postWall
                
            case .training: storyboard = .trainingMenu
                
            case .profile: storyboard = .profile
            }
            
            let controller = storyboard?.instantiateInitialViewController()
            
            controller?.tabBarItem = tabBarItem()
            
            return controller
        }
        
        private func tabBarItem() -> UITabBarItem {
            
            var imageAsset: UIImage.Asset
            
            switch self {
                
            case .postWall: imageAsset = .post
                
            case .training: imageAsset = .training
                
            case .profile: imageAsset = .profile
            }
            
            let tabBarItem = UITabBarItem()
            
            tabBarItem.image = UIImage.asset(imageAsset)
            
            let itemOffset: CGFloat = 5.5
            
            tabBarItem.imageInsets = UIEdgeInsets(top: itemOffset, left: 0, bottom: -itemOffset, right: 0)
            
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
