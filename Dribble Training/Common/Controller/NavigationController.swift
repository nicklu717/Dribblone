//
//  NavigationController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/25.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationBar.isTranslucent = false
        
        navigationBar.tintColor = .b3
        
//        navigationBar.barTintColor = .b4
        
//        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.b1]
    }
}
