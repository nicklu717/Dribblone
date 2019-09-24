//
//  UIView+Extension.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/23.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable var CornerRadius: CGFloat {
        
        get { return layer.cornerRadius }
        
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var BorderWidth: CGFloat {
        
        get { return layer.borderWidth }
        
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var BorderColor: UIColor? {
        
        get {
            
            guard let borderColor = layer.borderColor
                else {
                    return nil
            }
            
            return UIColor(cgColor: borderColor)
        }
        
        set { layer.borderColor = newValue?.cgColor }
    }
}
