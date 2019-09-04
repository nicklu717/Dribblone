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
    
    // Training Mode
    var leftPosition = true
    
    func setTargetCoinWithRandomPosition() {
        
        coinNode.position = randomPosition()
        
        addChild(coinNode)
    }
    
    func setTargetCoinWithCrossover() {
        
        coinNode.position.y = size.height * 0.6
        
        leftPosition = !leftPosition
        
        if leftPosition {
            coinNode.position.x = size.width * 0.2
        } else {
            coinNode.position.x = size.width * 0.8
        }
        
        addChild(coinNode)
    }
    
    func setTargetCoinWithLow() {
        
        coinNode.position.y = size.height * 0.25
        
        let xScale = CGFloat(Double.random(in: 0.2...0.8))
        
        coinNode.position.x = size.width * xScale
        
        addChild(coinNode)
    }
    
    private func randomPosition() -> CGPoint {
        
        let xScale = CGFloat(Double.random(in: 0.2...0.8))
        let yScale = CGFloat(Double.random(in: 0.2...0.5))
        
        return CGPoint(x: size.width * xScale,
                       y: size.height * yScale)
    }
}
