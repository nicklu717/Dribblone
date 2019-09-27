//
//  CGRect.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/4.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import CoreGraphics

extension CGRect {
    
    func center() -> CGPoint {
        
        let x = origin.x + (width / 2)
        let y = origin.y + (height / 2)
        
        return CGPoint(x: x, y: y)
    }
}
