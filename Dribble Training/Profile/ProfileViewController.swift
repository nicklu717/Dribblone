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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrainingResultPage()
    }
    
    func showTrainingHistory() {
        
        trainingResultPage.trainingResults = StorageManager.shared.trainingResults
        
        show(trainingResultPage, sender: nil)
    }
    
    private func setupTrainingResultPage() {
        
        let storyboard = UIStoryboard.trainingResult
        
        guard
            let trainingResultViewController = storyboard.instantiateInitialViewController() as? TrainingResultViewController
            else {
                print("Training Result View Controller Not Exist")
                return
        }
        
        trainingResultPage = trainingResultViewController
    }
}
