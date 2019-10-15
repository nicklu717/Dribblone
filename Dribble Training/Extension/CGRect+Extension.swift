//
//  CGRect.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/4.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import CoreGraphics

extension CGRect {
    
    var center: CGPoint {
        
        let centerX = origin.x + (width / 2)
        
        let centerY = origin.y + (height / 2)
        
        return CGPoint(x: centerX, y: centerY)
    }
}
