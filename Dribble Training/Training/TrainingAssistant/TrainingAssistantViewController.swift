//
//  TrainingAssistantViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/5.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import SpriteKit

protocol TrainingAssistantViewControllerDelegate: AnyObject {
    
    func endTraining(points: Int, trainingMode: TrainingMode)
}

class TrainingAssistantViewController: UIViewController {
    
    weak var delegate: TrainingAssistantViewControllerDelegate?
    
    @IBOutlet var trainingAssistantView: TrainingAssistantView! {
        didSet {
            trainingAssistantView.physicsContactDelegate = self
        }
    }
    
    private var points: Int = 0 {
        didSet {
            trainingAssistantView.setPointsLabel(points)
        }
    }
    
    private var minute: Int = 0
    private var second: Int = 0 {
        didSet {
            trainingAssistantView.setTimerLabel(minute: minute, second: second)
        }
    }
    
    private var timer: Timer?
    
    private var trainingMode: TrainingMode = .crossover
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetTimer()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(startTraining),
                                               name: .startTraining,
                                               object: nil)
    }
    
    // MARK: - Instance Method
    
    func resetTimer(minute: Int = 0, second: Int = 20) {
        
        self.minute = minute
        self.second = second
        
        self.points = 0
    }
    
    @objc func startTraining() {
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(countdown),
                                     userInfo: nil,
                                     repeats: true)
        
        trainingAssistantView.resetTargetNode(mode: trainingMode)
    }
    
    func setBallNode(to position: CGPoint) {
        trainingAssistantView.moveBallNode(to: position)
    }
    
    func setDelegate(_ delegate: TrainingAssistantViewControllerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Private Method
    
    private func getPoint() {
        
        points += 3
        
        trainingAssistantView.resetTargetNode(mode: trainingMode)
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
        
        resetTimer()
        
        trainingAssistantView.startButton.isHidden = false
        
        trainingAssistantView.targetNode.removeFromParent()
        
        delegate?.endTraining(points: points, trainingMode: trainingMode)
    }
}

extension TrainingAssistantViewController: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        getPoint()
    }
}
