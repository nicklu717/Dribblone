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
    
    var trainingPage: TrainingViewController!
    
    var trainingResultPage: TrainingResultViewController!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrainingManagerPage()
        
        setupTrainingResultPage()
    }
    
    // MARK: - Instance Method
    
    func startTraining(mode: TrainingMode) {
        
        trainingPage.setTrainingMode(to: mode)
        
        trainingPage.trainingCompletion = { [weak self]
            
            trainingResult in
            
            guard let self = self else { return }
            
            self.trainingResultPage.trainingResults = [trainingResult]
            
            self.show(self.trainingResultPage, sender: nil)
        }
        
        present(trainingPage, animated: true, completion: nil)
    }
    
    // MARK: - Private Method
    
    private func setupTrainingManagerPage() {
        
        let storyboard = UIStoryboard.training
        
        let viewController = storyboard.instantiateInitialViewController()
        
        trainingPage = viewController as? TrainingViewController
        
        trainingPage.loadViewIfNeeded()
    }
    
    private func setupTrainingResultPage() {
        
        let storyboard = UIStoryboard.trainingResult
        
        let viewController = storyboard.instantiateInitialViewController()
        
        trainingResultPage = viewController as? TrainingResultViewController
        
        trainingResultPage.navigationItem.title = "Result"
        
        trainingResultPage.loadViewIfNeeded()
    }
}
