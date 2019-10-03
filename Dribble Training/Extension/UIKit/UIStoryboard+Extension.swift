//
//  UIStoryboard+Extension.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static let tabBar = storyboard("TabBar")
    
    static let main = storyboard("Main")
    
    static let register = storyboard("Register")
    
    static let postWall = storyboard("PostWall")
    
    static let trainingMenu = storyboard("TrainingMenu")
    
    static let instruction = storyboard("Instruction")
    
    static let training = storyboard("Training")
    
    static let profile = storyboard("Profile")
    
    private static func storyboard(_ name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
}
