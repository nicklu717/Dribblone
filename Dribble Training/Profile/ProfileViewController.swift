//
//  ProfileViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/11.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, TrainingResultViewControllerDataSource {
    
    // MARK: - Property Declaration
    
    @IBOutlet var profileView: ProfileView!
    
    var member: Member! {
        
        didSet {
            
            setupProfileView()
            setupTrainingResultPage()
        }
    }
    
    private var trainingResultPage: TrainingResultViewController!
    
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//
//
//    }
    
    // MARK: - Instance Method
    
    private func setupProfileView() {
        
        loadViewIfNeeded()
        
        navigationItem.title = member.id
        
        profileView.setupProfile(for: member)
    }
    
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
        
        trainingResultPage.dataSource = self
        
        trainingResultPage.loadViewIfNeeded()
        
        fetchTrainingResult()
        
        showTrainingResultPage()
    }
    
    func fetchTrainingResult() {
        
        FirestoreManager.shared.fetchTrainingResult(for: member) { result in
            
            switch result {
                
            case .success(let trainingResults):
                
                self.trainingResultPage.trainingResults = trainingResults
                self.trainingResultPage.endRefreshing()
                
            case .failure(let error):
                
                print(error)
            }
        }
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
