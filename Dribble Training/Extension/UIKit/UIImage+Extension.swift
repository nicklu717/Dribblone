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
        
        static let urls: [String] = [a1, a2, a3, a4, a5, a6, a7]
        
        static let a1 = "\(storageURL)a1.jpg?alt=media&token=124feb2a-eae9-449c-be36-262a06911954"
        
        static let a2 = "\(storageURL)a2.jpg?alt=media&token=fad93bce-e087-4f79-9618-27ef55678725"
        
        static let a3 = "\(storageURL)a3.jpg?alt=media&token=82854f51-523b-41b0-ad97-0d937a4b774b"
        
        static let a4 = "\(storageURL)a4.jpg?alt=media&token=6c178dc9-2963-4a5b-8862-fbfa9afc9e94"
        
        static let a5 = "\(storageURL)a5.jpg?alt=media&token=9e3a122d-f2de-46fe-aab8-7b17204737e8"
        
        static let a6 = "\(storageURL)a6.jpg?alt=media&token=79351072-5be2-4926-b650-a2354b514726"
        
        static let a7 = "\(storageURL)a7.jpg?alt=media&token=d2f3cfbc-1df9-4c94-9913-5f77870d913b"
        
        private static let storageURL = "https://firebasestorage.googleapis.com/v0/b/dribble-training.appspot.com/o/background_image%2F"
    }
}
