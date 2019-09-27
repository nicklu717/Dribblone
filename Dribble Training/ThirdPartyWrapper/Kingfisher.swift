//
//  Kingfisher.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/25.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(withURLString urlString: String, placeholder: UIImage? = nil) {
        
        guard let url = URL(string: urlString) else { return }
        
        kf.setImage(with: url, placeholder: placeholder)
    }
}
