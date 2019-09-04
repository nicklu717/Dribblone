//
//  TrainingView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/3.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import SpriteKit

protocol TrainingViewDelegate: AnyObject {
    
    func startScreenRecording()
    
    func stopScreenRecording()
}

class TraingingView: SKView {
    
    // MARK: - Property Declaration
    
    var trainingScene: TrainingScene?
    
    weak var replayDelegate: TrainingViewDelegate? {
        didSet {
            initialize()
        }
    }
    
    var cancelButton: UIButton! {
        
        didSet {
            
            cancelButton.setImage(UIImage(named: "close"), for: .normal)
            cancelButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            
            cancelButton.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
            
            cancelButton.layer.cornerRadius = 10
            cancelButton.clipsToBounds = true
            
            cancelButton.frame = CGRect(x: 55, y: 25, width: 45, height: 45)
            
            addSubview(cancelButton)
        }
    }
    
    var startButton: UIButton! {
        
        didSet {
            
            startButton.setTitle("START", for: .normal)
            startButton.setTitleColor(UIColor(white: 0.8, alpha: 1), for: .normal)
            startButton.titleLabel?.font = UIFont.systemFont(ofSize: 55)
            
            startButton.backgroundColor = UIColor(white: 0.2, alpha: 1)
            
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
    
    var timerLabel: UILabel! {
        
        didSet {
            
            timerLabel.textColor = UIColor(white: 0.8, alpha: 1)
            timerLabel.font = UIFont(name: "Helvetica Neue", size: 55)
            
            timerLabel.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
            
            timerLabel.layer.cornerRadius = 10
            timerLabel.clipsToBounds = true
            
            addSubview(timerLabel)
            
            timerLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                timerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25),
                timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55)
            ])
        }
    }
    
    var timer: Timer?
    
    private var minute: Int!
    
    private var second: Int! {
        didSet {
            timerLabel.text = String(format: "%02d:%02d", minute, second)
        }
    }
    
    // MARK: - Instance Method
    
    func setTimer(minute: Int = 0, second: Int = 10) {
        
        self.minute = minute
        self.second = second
    }
    
    // MARK: - Private Method
    
    private func initialize() {
        
        backgroundColor = .clear
        
        cancelButton = UIButton()
        
        startButton = UIButton()
        
        timerLabel = UILabel()
        
        setTimer()
    }
    
    func setUpTrainingScene() {
        
        trainingScene = TrainingScene()
        
        trainingScene?.scaleMode = .resizeFill
        
        trainingScene?.backgroundColor = .clear
        
        trainingScene?.ballNode.position = CGPoint(x: -100, y: -100)
        trainingScene?.ballNode.name = "ball"
        trainingScene?.ballNode.fillColor = .red
        
        trainingScene?.addChild(trainingScene!.ballNode)
        
        presentScene(trainingScene)
    }
    
    @objc private func startTraining() {
        
        startButton.isHidden = true
        
        replayDelegate?.startScreenRecording()
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(countdown),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc private func countdown() {
        
        if second <= 0 {
            
            if minute > 0 {
                
                minute -= 1
                second = 60
                
            } else {
                
                endTraining()
                return
            }
        }
        
        second -= 1
    }
    
    private func endTraining() {
        
        print("Time's Up")
        
        timer?.invalidate()
        
        replayDelegate?.stopScreenRecording()
    }
}
