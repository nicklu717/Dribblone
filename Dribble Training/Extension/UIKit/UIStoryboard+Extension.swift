//
//  UIStoryboard+Extension.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static var tabBar: UIStoryboard { return storyboard("TabBar") }
    
    static var main: UIStoryboard { return storyboard("Main") }
    
    static var register: UIStoryboard { return storyboard("Register") }
    
    static var postWall: UIStoryboard { return storyboard("PostWall") }
    
    static var trainingMenu: UIStoryboard { return storyboard("TrainingMenu")}
    
    static var training: UIStoryboard { return storyboard("Training")}
    
    static var profile: UIStoryboard { return storyboard("Profile") }
    
    private static func storyboard(_ name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
}
