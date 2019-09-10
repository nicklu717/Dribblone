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
    
    private enum Tab {
        
        case home
        
        case classroom
        
        case training
        
        case profile
        
        case team
        
        func controller() -> UIViewController? {
            
            var storyboard: UIStoryboard?
            
            switch self {
                
            case .home: storyboard = .home
                
            case .classroom: storyboard = .classroom
                
            case .training: storyboard = .trainingLobby
                
            case .profile: storyboard = .profile
                
            case .team: storyboard = .team
            }
            
            return storyboard?.instantiateInitialViewController()
        }
    }
}
