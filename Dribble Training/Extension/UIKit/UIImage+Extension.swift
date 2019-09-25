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
        case edit = "Edit"
        case play = "Play"
        case post = "Post"
        case profile = "Profile"
        case settings = "Settings"
        case team = "Team"
        case training = "Training"
        case video = "Video"
    }
    
    struct Background {
        
        static let a1 = "https://firebasestorage.googleapis.com/v0/b/dribble-training.appspot.com/o/background_image%2Fball-1837119_1920.jpg?alt=media&token=953c10f6-5f5c-4ffb-b5b3-18dfb9dae14d"
        
        static let a2 = "https://firebasestorage.googleapis.com/v0/b/dribble-training.appspot.com/o/background_image%2Fmarcel-schreiber-iZI5qcR7f8s.jpg?alt=media&token=af365473-fe7c-418d-910d-366f57c18ef4"
        
        static let a3 = "https://firebasestorage.googleapis.com/v0/b/dribble-training.appspot.com/o/background_image%2Foutdoor-basketball-1639860_1920.jpg?alt=media&token=1ea6c2c0-40cd-459c-8284-626b714070e4"
        
        static let a4 = "https://firebasestorage.googleapis.com/v0/b/dribble-training.appspot.com/o/background_image%2Ftom-pottiger-fz92ybo3N0M.jpg?alt=media&token=61609f5a-013a-4593-bbab-b1290bb0b892"
        
        static let a5 = "https://firebasestorage.googleapis.com/v0/b/dribble-training.appspot.com/o/background_image%2Fvidar-nordli-mathisen-mCkoBB69Qf8.jpg?alt=media&token=acd696b2-6131-4a14-ae1f-10d45b0016f4"
    }
}
