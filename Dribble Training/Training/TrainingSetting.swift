//
//  TrainingSetting.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/4.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

struct TrainingViewControllerSegue {
    
    static let ballTracker = "BallTracker"
    
    static let trainingAssistant = "TrainingAssistant"
}

enum TrainingMode: String {
    
    case random = "Random"
    
    case crossover = "Crossover"
    
    case low = "Low"
}

enum SceneNode {
    
    case ball
    
    case target
    
    var categoryMask: UInt32 {
        
        switch self {
        
        case .ball: return 0001
        case .target: return 0010
        }
    }
}
