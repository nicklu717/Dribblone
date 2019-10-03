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
    
    case rightHand = "One Hand: Right"
    
    case leftHand = "One Hand: Left"
    
    case mStyle = "M Style"
    
    var description: String {
        
        var description: String!
        
        switch self {
            
        case .crossover:
            
            description = ""
            
        case .low:
        
            description = ""
            
        case .rightHand, .leftHand:
        
            description = ""
            
        case .mStyle:
        
            description = ""
            
        case .random:
        
            description = ""
        }
        
        return description
    }
    
    var videoID: String {
        
        var id: String!
        
        switch self {
            
        case .crossover:
            
            id = ""
            
        case .low:
        
            id = ""
            
        case .rightHand, .leftHand:
        
            id = ""
            
        case .mStyle:
        
            id = ""
            
        case .random:
        
            id = ""
        }
        
        return id
    }
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
