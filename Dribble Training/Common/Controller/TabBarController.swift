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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        for tab in tabs {
            
            guard
                let viewController = tab.controller()
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
            
            let inset: CGFloat = 3.3
            tabBarItem.imageInsets = UIEdgeInsets(top: inset,
                                                  left: inset,
                                                  bottom: inset,
                                                  right: inset)
            
            tabBarItem.title = imageAsset.rawValue
            
            return tabBarItem
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.tabBarItem.title == UIImage.Asset.profile.rawValue,
            MemberManager.shared.currentUser == nil {
            
            let storyboard = UIStoryboard.register
            
            if let registerPage = storyboard.instantiateInitialViewController() as? RegisterViewController {
            
                present(registerPage, animated: true, completion: nil)
                
                return false
            }
        }
        
        return true
    }
}
