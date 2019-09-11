//
//  UIImage+Extension.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/10.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func asset(_ asset: Asset) -> UIImage? {
        return UIImage(named: asset.rawValue)
    }
    
    enum Asset: String {
        
        case close = "Close"
        case play = "Play"
        case post = "Post"
        case team = "Team"
        case training = "Training"
        case profile = "Profile"
        case video = "Video"
    }
}
