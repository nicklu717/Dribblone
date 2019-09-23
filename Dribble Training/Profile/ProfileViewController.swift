//
//  ProfileViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/11.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Property Declaration
    
    @IBOutlet var profileView: ProfileView!
    
    private var trainingResultPage: TrainingResultViewController!
    
    // MARK: - Instance Method
    
    func setupProfileView(member: Member) {
        
        loadViewIfNeeded()
        
        navigationItem.title = member.id
        
        profileView.setupProfile(for: member)
        
        setupTrainingResultPage(member: member)
    }
    
    func setupTrainingResultPage(member: Member) {
        
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
        
        FirestoreManager.shared.fetchTrainingResult(for: member) { result in
            
            switch result {
                
            case .success(let trainingResults):
                
                self.trainingResultPage.trainingResults = trainingResults
                
            case .failure(let error):
                
                print(error)
            }
        }
        
        showTrainingResultPage()
    }
    
    func beingPushed() {
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        
        profileView.followButton.isHidden = false
        profileView.blockButton.isHidden = false
    }
    
    private func showTrainingResultPage() {
        
        profileView.trainingResultPageView.addSubview(trainingResultPage.view)
        
        trainingResultPage.view.frame = profileView.trainingResultPageView.bounds
        
        addChild(trainingResultPage)
        
        trainingResultPage.didMove(toParent: self)
    }
}
