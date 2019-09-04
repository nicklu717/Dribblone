//
//  TrainingNode.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/4.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Foundation

//enum TrainingMode {
//    
//    case random
//    
//    case crossover
//    
//    case low
//}

enum TrainingNode {
    
    case ball
    
    case coin
    
    var categoryMask: UInt32 {
        
        switch self {
        case .ball: return 0001
        case .coin: return 0010
        }
    }
}
