//
//  TrainingScene.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/3.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import SpriteKit

class TrainingScene: SKScene {
    
    func addTargetCoin() {
        
        let coin = SKSpriteNode(imageNamed: "coin")
        
        coin.position = randomPosition()
        coin.size = CGSize(width: 80, height: 80)
        
        coin.name = "coin"
        
        addChild(coin)
        
        print("coin")
    }
    
    private func randomPosition() -> CGPoint {
        
        let xScale = CGFloat(Double.random(in: 0.2...0.8))
        let yScale = CGFloat(Double.random(in: 0.2...0.6))
        
        return CGPoint(x: size.width * xScale,
                       y: size.height * yScale)
    }
}
