//
//  TrainingLobbyViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class TrainingLobbyViewController: UIViewController, TrainingLobbyViewDelegate {
    
    // MARK: - Property Declartion
    
    @IBOutlet var trainingLobbyView: TrainingLobbyView! {
        didSet {
            trainingLobbyView.delegate = self
        }
    }
    
    var trainingManagerViewController: TrainingManagerViewController!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrainingManager()
    }
    
    // MARK: - Instance Method
    
    func startTraining(mode: TrainingMode) {
        
        trainingManagerViewController.setTrainingMode(to: mode)
        present(trainingManagerViewController, animated: true, completion: nil)
    }
    
    // MARK: - Private Method
    
    private func setupTrainingManager() {
        
        let storyboard = UIStoryboard.training
        
        trainingManagerViewController =
            storyboard.instantiateInitialViewController() as? TrainingManagerViewController
        
        trainingManagerViewController.loadViewIfNeeded()
    }
}
