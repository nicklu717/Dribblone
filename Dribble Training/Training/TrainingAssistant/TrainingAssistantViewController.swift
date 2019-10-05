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
    
    func fakeRecordingForPermission()
    
    func startRecording()
    
    func cancelRecording()
    
    func endTraining(points: Int, trainingMode: String)
}

class TrainingAssistantViewController: UIViewController {
    
    weak var delegate: TrainingAssistantViewControllerDelegate?
    
    @IBOutlet var trainingAssistantView: TrainingAssistantView! {
        didSet {
            trainingAssistantView.viewDelegate = self
        }
    }
    
    private var points: Int = 0 {
        didSet {
            trainingAssistantView.setPointsLabel(points)
        }
    }
    
    private var trainingTime = Time() {
        didSet {
            trainingAssistantView.setTimerLabel(minute: trainingTime.minute,
                                                second: trainingTime.second)
        }
    }
    
    private var preparingTime = Time() {
        didSet {
            trainingAssistantView.setPreparingCountdownLabel(to: preparingTime.second)
        }
    }
    
    private var timer: Timer?
    
    var trainingMode: TrainingMode!
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        resetTraining()
    }
    
    // MARK: - Instance Method
    
    func resetTraining() {
        
        trainingTime = Time.training
        
        points = .zero
        
        trainingAssistantView.startButton.isHidden = false
        
        trainingAssistantView.preparingCountdownLabel.isHidden = true
        
        trainingAssistantView.targetNode.removeFromParent()
    }
    
    func setBallNode(to position: CGPoint) {

        trainingAssistantView.moveBallNode(to: position)
    }
    
    // MARK: - Private Method
    
    private func getPoint() {
        
        points += Point.normal
        
        trainingAssistantView.resetTargetNode(mode: trainingMode)
    }
    
    private func startTraining() {
        
        trainingAssistantView.preparingCountdownLabel.isHidden = true
        
        delegate?.cancelRecording()
        
        delegate?.startRecording()
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(countdown),
            userInfo: nil,
            repeats: true
        )
        
        trainingAssistantView.resetTargetNode(mode: trainingMode)
        
        trainingAssistantView.targetNode.isHidden = false
    }
    
    @objc private func countdown() {
        
        trainingTime.countdown()
        
        if trainingTime.isZero {
            
            endTraining()
        }
    }
    
    private func endTraining() {
        
        timer?.invalidate()
        
        delegate?.endTraining(points: points, trainingMode: trainingMode.rawValue)
    }
}

extension TrainingAssistantViewController: TrainingAssistantViewDelegate {
    
    func startPreparingCountdown() {
        
        delegate?.fakeRecordingForPermission()
        
        preparingTime = Time.trainingPrepare
        
        trainingAssistantView.preparingCountdownLabel.isHidden = false
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(preparingCountdown),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func preparingCountdown() {
        
        preparingTime.countdown()
        
        if preparingTime.isZero {
            
            timer?.invalidate()
            
            startTraining()
        }
    }
    
    func cancelTraining() {
        
        if let timer = timer, timer.isValid {
            
            timer.invalidate()
        }
        
        delegate?.cancelRecording()
        
        dismiss(animated: true, completion: nil)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        getPoint()
    }
}
