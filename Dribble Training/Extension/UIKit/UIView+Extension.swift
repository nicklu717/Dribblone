//
//  UIView+Extension.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/23.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

extension UIView {
    
    func flashBackground(with color: UIColor?, duration: TimeInterval){
        
        let originColor = backgroundColor
        
        changeBackgroundColor(to: color, duration: duration) {
            self.changeBackgroundColor(to: originColor, duration: duration)
        }
    }
    
    func changeBackgroundColor(to color: UIColor?,
                               duration: TimeInterval,
                               completion: (() -> Void)? = nil) {
        
        UIView.animate(withDuration: duration,
                       animations: { self.backgroundColor = color },
                       completion: { _ in completion?() })
    }
}

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