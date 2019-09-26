////
////  CALayer.swift
////  Dribble Training
////
////  Created by 陸瑋恩 on 2019/9/26.
////  Copyright © 2019 陸瑋恩. All rights reserved.
////
//
//import UIKit
//
//extension CALayer {
//    
//    func screenShot() -> UIImage? {
//        
//        UIGraphicsBeginImageContext(bounds.size)
//        
//        guard let currentContext = UIGraphicsGetCurrentContext()
//            else {
//                print("Couldn't Get Current Context")
//                UIGraphicsEndImageContext()
//                return nil
//        }
//        
//        render(in: currentContext)
//        
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        
//        UIGraphicsEndImageContext()
//        
//        return image
//    }
//}
