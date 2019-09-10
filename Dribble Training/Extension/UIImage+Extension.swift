//
//  UIImage+Extension.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/10.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

extension UIImage {
    
    enum Asset: String {
        
        case ball_selected
        case ball
        case close
        case play
        case post
        case team
        case user
        case video
        
        func image() -> UIImage? {
            return UIImage(named: self.rawValue)
        }
    }
}
