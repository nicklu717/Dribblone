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
            
            description = "Crossover!!!!!!!!"
            
        case .low:
        
            description = "Low Low Low Low"
            
        case .rightHand, .leftHand:
        
            description = "大力運就對了"
            
        case .mStyle:
        
            description = "Combination of power dribbles & crossover dribbles"
            
        case .random:
        
            description = "Dribble as you like"
        }
        
        return description
    }
    
    var videoID: String {
        
        var id: String!
        
        switch self {
            
        case .crossover:
            
            id = "lMl5dnlNdnA"
            
        case .low:
        
            id = "UnRklE9VON4"
            
        case .rightHand, .leftHand:
        
            id = "aldZhfOAW-4"
            
        case .mStyle:
        
            id = "M3yD-gwjoRE"
            
        case .random:
        
            id = "GdtS-yaGHY"
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
