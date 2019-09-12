//
//  ProfileViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/11.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ProfileViewDelegate {
    
    @IBOutlet var profileView: ProfileView! {
        didSet {
            profileView.delegate = self
        }
    }
    
    var trainingResultPage: TrainingResultViewController!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrainingResultPage()
    }
    
    // MARK: - Instance Method
    
    func showTrainingHistory() {
        
        trainingResultPage.trainingResults = FirestoreManager.shared.trainingResults
        
        trainingResultPage.navigationItem.title = "Training History"
        
        show(trainingResultPage, sender: nil)
    }
    
    // MARK: - Private Method
    
    private func setupTrainingResultPage() {
        
        let storyboard = UIStoryboard.trainingResult
        
        guard
            let trainingResultViewController = storyboard.instantiateInitialViewController()
                as? TrainingResultViewController
            else {
                print("Training Result View Controller Not Exist")
                return
        }
        
        trainingResultPage = trainingResultViewController
        
        trainingResultPage.loadViewIfNeeded()
    }
}
