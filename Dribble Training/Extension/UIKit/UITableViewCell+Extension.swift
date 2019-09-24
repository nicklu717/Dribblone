//
//  UITableViewCell+Extension.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/24.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    static var id: String {
        return String(describing: self.self)
    }
}
