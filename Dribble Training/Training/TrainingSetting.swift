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
            
            description = "Cross the ball continuously in front of your body."
            
        case .low:
        
            description = "Dribble the basketball a couple of inches off the ground with your fingertips."
            
        case .rightHand, .leftHand:
        
            description = "Pound the ball as hard as you can into the ground at around waist height with the same hand."
            
        case .mStyle:
        
            description = "One pound dribble with one crossover dribble.\nDraw an 'M' with your basketball."
            
        case .random:
        
            description = "Random target points on screen.\nTry your limitation of reaction!"
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
        
            id = "-GdtS-yaGHY"
        }
        
        return id
    }
}

struct Time {
    
    var minute: Int = 0
    
    var second: Int = 0
    
    var isZero: Bool {
        
        return minute == 0 && second == 0
    }
    
    static let training = Time(minute: 0, second: 10)
    
    static let trainingPrepare = Time(minute: 0, second: 3)
    
    mutating func countdown() {
        
        if second <= 0 {
            
            if minute > 0 {
                
                minute -= 1
                second = 60
                
            } else { return }
        }
        
        second -= 1
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
