//
//  UICollectionView+Extension.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/10/1.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func registerCellWithNib(id: String, bundle: Bundle? = nil) {
        let nib = UINib(nibName: id, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: id)
    }
}
