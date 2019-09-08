//
//  TrainingAssistantView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/3.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import SpriteKit

class TrainingAssistantView: SKView {
    
    // MARK: - Property Declaration
    
    weak var physicsContactDelegate: SKPhysicsContactDelegate? {
        
        didSet {
            
            setUpUI()
            
            setUpScene()
        }
    }
    
    let ballNode = SKShapeNode(circleOfRadius: 30)
    
    let targetNode = SKShapeNode(circleOfRadius: 30)
    
    var pointsLabel: UILabel! {
        
        didSet {
            
            pointsLabel.text = "00"
            pointsLabel.textColor = UIColor(white: 0.8, alpha: 1)
            pointsLabel.font = UIFont(name: "Helvetica Neue", size: 55)
            
            pointsLabel.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
            
            pointsLabel.layer.cornerRadius = 10
            pointsLabel.clipsToBounds = true
            
            addSubview(pointsLabel)
            
            pointsLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                pointsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
                pointsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25)
            ])
        }
    }
    
    var timerLabel: UILabel! {
        
        didSet {
            
            timerLabel.text = "00:00"
            timerLabel.textColor = UIColor(white: 0.8, alpha: 1)
            timerLabel.font = UIFont(name: "Helvetica Neue", size: 55)
            
            timerLabel.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
            
            timerLabel.layer.cornerRadius = 10
            timerLabel.clipsToBounds = true
            
            addSubview(timerLabel)
            
            timerLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55),
                timerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25)
            ])
        }
    }
    
    var startButton: UIButton! {
        
        didSet {
            
            startButton.setTitle("START", for: .normal)
            startButton.setTitleColor(UIColor(white: 0.8, alpha: 1), for: .normal)
            startButton.titleLabel?.font = UIFont.systemFont(ofSize: 55)
            
            startButton.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
            
            startButton.layer.cornerRadius = 10
            startButton.clipsToBounds = true
            
            startButton.addTarget(self,
                                  action: #selector(startTraining),
                                  for: .touchUpInside)
            
            addSubview(startButton)
            
            startButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
            ])
        }
    }
    
    var cancelButton: UIButton! {

        didSet {

            cancelButton.setImage(UIImage(named: "close"), for: .normal)

            cancelButton.backgroundColor = UIColor(white: 0.2, alpha: 0.8)

            cancelButton.layer.cornerRadius = 10
            cancelButton.clipsToBounds = true
            
            cancelButton.imageEdgeInsets = UIEdgeInsets(top: 10,
                                                        left: 10,
                                                        bottom: 10,
                                                        right: 10)

//            cancelButton.addTarget(self,
//                                  action: #selector(cancelTraining),
//                                  for: .touchUpInside)

            addSubview(cancelButton)

            cancelButton.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
                cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 25),
                cancelButton.widthAnchor.constraint(equalToConstant: 50),
                cancelButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    private var leftPosition = true
    
    // MARK: - Instance Method
    
    func setPhysicsContactDelegate(_ delegate: SKPhysicsContactDelegate?) {
        physicsContactDelegate = delegate
    }
    
    func setPointsLabel(_ points: Int) {
        pointsLabel.text = String(format: "%02d", points)
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
    
    // MARK: - Private Method
    
    private func setUpUI() {
        
        pointsLabel = UILabel()
        
        startButton = UIButton()
        
        timerLabel = UILabel()
        
        cancelButton = UIButton()
    }
    
    private func setUpScene() {
        
        // Set Up Scene
        
        let scene = SKScene()
        
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        
        scene.physicsWorld.contactDelegate = physicsContactDelegate
        
        presentScene(scene)
        
        // Set Up Ball Node
        
        ballNode.position = CGPoint(x: -100, y: -100)
        
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        ballNode.physicsBody?.affectedByGravity = false
        ballNode.physicsBody?.categoryBitMask = SceneNode.ball.categoryMask
        
        scene.addChild(ballNode)
        
        // Set Up Coin Node
        
        targetNode.fillColor = .red
        
        targetNode.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        targetNode.physicsBody?.affectedByGravity = false
        targetNode.physicsBody?.categoryBitMask = SceneNode.target.categoryMask
        targetNode.physicsBody?.contactTestBitMask =
            SceneNode.ball.categoryMask | SceneNode.target.categoryMask
    }
    
    @objc private func startTraining() {
        
        startButton.isHidden = true
        
        NotificationCenter.default.post(Notification(name: .startTraining))
    }
    
    private func targetNodePosition(mode: TrainingMode) -> CGPoint {
        
        var xScale: CGFloat!
        var yScale: CGFloat!
        
        switch mode {
            
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
        
        return CGPoint(x: bounds.width * xScale, y: bounds.height * yScale)
    }
}
