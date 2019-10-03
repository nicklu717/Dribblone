//
//  InstructionViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/10/3.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {
    
    // MARK: - Property Declartion
    
    @IBOutlet var instructionView: InstructionView!
    
    var trainingMode: TrainingMode!
    
    private var trainingPage: TrainingViewController!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTrainingPage()
    }
    
    // MARK: - Instance Method
    
    @IBAction func startTraining() {
        
        trainingPage.setTrainingMode(to: trainingMode)

        present(trainingPage, animated: true, completion: nil)
    }
    
    // MARK: - Private Method
    
    private func setupTrainingPage() {
        
        let trainingStoryboard = UIStoryboard.training
        
        let viewController = trainingStoryboard.instantiateInitialViewController()
        
        trainingPage = viewController as? TrainingViewController
        
        trainingPage.loadViewIfNeeded()
    }
}
