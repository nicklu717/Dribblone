//
//  TrainingScene.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/3.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import SpriteKit

class TrainingScene: SKScene {
    
    let ballNode = SKShapeNode(circleOfRadius: 30)
    
    let coinNode = SKSpriteNode(imageNamed: "coin")
    
    var trainingMode: TrainingMode = .crossover
    
    private var leftPosition = true
    
    func setTargetPoint() {

        coinNode.position = coinPosition()
        
        addChild(coinNode)
    }
    
    private func coinPosition() -> CGPoint {
        
        var xScale: CGFloat!
        var yScale: CGFloat!
        
        switch trainingMode {
        
        case .crossover:
            
            leftPosition = !leftPosition
            xScale = leftPosition ? 0.2 : 0.8
            yScale = 0.6
            
        case .low:
            
            xScale = CGFloat(Double.random(in: 0.2...0.8))
            yScale = 0.25
            
        case .random:
            
            xScale = CGFloat(Double.random(in: 0.2...0.8))
            yScale = CGFloat(Double.random(in: 0.2...0.5))
        }
        
        return CGPoint(x: size.width * xScale, y: size.height * yScale)
    }
}
