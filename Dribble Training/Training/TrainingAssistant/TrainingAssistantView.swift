//
//  TrainingAssistantView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/3.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import SpriteKit

protocol TrainingAssistantViewDelegate: SKPhysicsContactDelegate {
    
    func startPreparingCountdown()
    
    func cancelTraining()
}

class TrainingAssistantView: SKView {
    
    // MARK: - Property Declaration
    
    weak var viewDelegate: TrainingAssistantViewDelegate? {
        didSet {
            setUpScene()
        }
    }
    
    let ballNode = SKShapeNode(circleOfRadius: 30)
    
    let targetNode = SKShapeNode(circleOfRadius: 30)
    
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var preparingCountdownLabel: UILabel!
    
    @IBOutlet var cancelButton: UIButton! {
        
        didSet {
            
            let inset: CGFloat = 5
            
            cancelButton.imageEdgeInsets =
                UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        }
    }
    
    private var positionX: Position.X = .left
    private var positionY: Position.Y = .high
    
    private var xScale: CGFloat!
    private var yScale: CGFloat!
    
    // MARK: - Instance Method
    
    func setPreparingCountdownLabel(to second: Int) {
        
        if second <= 0 {
            
            preparingCountdownLabel.text = "Go!"
            
        } else {
            
            preparingCountdownLabel.text = String(second)
        }
    }
    
    func setPointsLabel(_ points: Int) {
        
        pointsLabel.text = String(format: "%03d", points)
    }
    
    func setTimerLabel(minute: Int, second: Int) {
        
        timerLabel.text = String(format: "%02d:%02d", minute, second)
    }
    
    func resetTargetNode(mode: TrainingMode) {
        
        targetNode.removeFromParent()
        
        targetNode.position = targetNodePosition(mode: mode)
        
        scene?.addChild(targetNode)
    }
    
    func moveBallNode(to position: CGPoint) {
        
        guard let scene = scene else { return }
        
        let convertedPosition = scene.convertPoint(fromView: position)
        
        let moveAction = SKAction.move(to: convertedPosition, duration: 1/30)
        
        ballNode.run(moveAction)
    }
    
    @IBAction func startTraining() {
        
        startButton.isHidden = true
        
        viewDelegate?.startPreparingCountdown()
    }
    
    @IBAction func cancelTraining() {
        
        viewDelegate?.cancelTraining()
    }
    
    // MARK: - Private Method
    
    private func setUpScene() {
        
        // Set Up Scene
        
        let scene = SKScene()
        
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        
        scene.physicsWorld.contactDelegate = viewDelegate
        
        presentScene(scene)
        
        // Set Up Ball Node
        
        ballNode.lineWidth = 0
        
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        ballNode.physicsBody?.affectedByGravity = false
        ballNode.physicsBody?.categoryBitMask = SceneNode.ball.categoryMask
        
        scene.addChild(ballNode)
        
        // Set Up Target Node
        
        targetNode.fillColor = .b2
        
        targetNode.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        targetNode.physicsBody?.affectedByGravity = false
        targetNode.physicsBody?.categoryBitMask = SceneNode.target.categoryMask
        targetNode.physicsBody?.contactTestBitMask =
            SceneNode.ball.categoryMask | SceneNode.target.categoryMask
    }
    
    // swiftlint:disable cyclomatic_complexity
    private func targetNodePosition(mode: TrainingMode) -> CGPoint {
        
        switch mode {
            
        case .rightHand:
            
            positionX = .right
            
            switch positionY {
            case .high: positionY = .low
            case .low: positionY = .high
            }
            
        case .leftHand:
            
            positionX = .left
            
            switch positionY {
            case .high: positionY = .low
            case .low: positionY = .high
            }
            
        case .crossover:
            
            switch positionX {
            case .left: positionX = .right
            case .right: positionX = .left
            default: positionX = .left
            }
            
            positionY = .high
            
        case .mStyle:
            
            switch positionX {
            case .left: positionX = .centerRight
            case .centerRight: positionX = .right
            case .right: positionX = .centerLeft
            case .centerLeft: positionX = .left
            default: positionX = .left
            }
            
            positionY = .low
            
        case .low:

            switch positionX {
            case .left: positionX = .centerRight
            case .centerRight: positionX = .right
            case .right: positionX = .centerLeft
            case .centerLeft: positionX = .left
            default: positionX = .left
            }
            
            positionY = .low
        
        case .random: break
        }
        
        xScale = positionX.rawValue
        yScale = positionY.rawValue
        
        if mode == .random {
            
            xScale = CGFloat(Double.random(in: 0.2...0.8))
            yScale = CGFloat(Double.random(in: 0.2...0.6))
        }
        
        return CGPoint(x: bounds.width * xScale, y: bounds.height * yScale)
    }
    // swiftlint:enable cyclomatic_complexity
    
    private struct Position {
        
        enum X: CGFloat {
            
            case left = 0.2
            
            case centerLeft = 0.45
            
            case center = 0.5
            
            case centerRight = 0.55
            
            case right = 0.8
        }
        
        enum Y: CGFloat {
            
            case low = 0.25
            
            case high = 0.6
        }
    }
}
