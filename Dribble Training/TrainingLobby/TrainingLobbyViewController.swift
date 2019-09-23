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
    
    var trainingManagerPage: TrainingManagerViewController!
    
    var trainingResultPage: TrainingResultViewController!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrainingManagerPage()
        
        setupTrainingResultPage()
    }
    
    // MARK: - Instance Method
    
    func startTraining(mode: TrainingMode) {
        
        trainingManagerPage.setTrainingMode(to: mode)
        
        trainingManagerPage.trainingCompletion = { [weak self]
            
            trainingResult in
            
            guard let self = self else { return }
            
            self.trainingResultPage.trainingResults = [trainingResult]
            
            self.show(self.trainingResultPage, sender: nil)
        }
        
        present(trainingManagerPage, animated: true, completion: nil)
    }
    
    // MARK: - Private Method
    
    private func setupTrainingManagerPage() {
        
        let storyboard = UIStoryboard.training
        
        let viewController = storyboard.instantiateInitialViewController()
        
        trainingManagerPage = viewController as? TrainingManagerViewController
        
        trainingManagerPage.loadViewIfNeeded()
    }
    
    private func setupTrainingResultPage() {
        
        let storyboard = UIStoryboard.trainingResult
        
        let viewController = storyboard.instantiateInitialViewController()
        
        trainingResultPage = viewController as? TrainingResultViewController
        
        trainingResultPage.navigationItem.title = "Result"
        
        trainingResultPage.loadViewIfNeeded()
    }
}
