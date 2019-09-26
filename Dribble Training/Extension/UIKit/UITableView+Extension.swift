//
//  UITableView+Extension.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/24.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerCellWithNib(id: String, bundle: Bundle? = nil) {
        
        let nib = UINib(nibName: id, bundle: bundle)
        
        register(nib, forCellReuseIdentifier: id)
    }
}
