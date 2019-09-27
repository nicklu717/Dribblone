//
//  PostWallViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/21.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class PostWallViewController: UIViewController, TrainingResultViewControllerDataSource {
    
    // MARK: - Property Declaration
    
    @IBOutlet var postWallView: PostWallView!
    
    private var trainingResultPage: TrainingResultViewController!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTrainingResultPage()
    }
    
    // MARK: - Instance Method
    
    func fetchTrainingResult() {
        
        FirestoreManager.shared.fetchTrainingResult { result in
            
            switch result {
                
            case .success(let trainingResults):
                
                var filteredTrainingResults: [TrainingResult] = []
                
                let blockList = AuthManager.shared.currentUser.blockList
                    
                for trainingResult in trainingResults {
                        
                    if !blockList.contains(trainingResult.id) {
                        
                        filteredTrainingResults.append(trainingResult)
                    }
                }
                
                self.trainingResultPage.trainingResults = filteredTrainingResults
                self.trainingResultPage.endRefreshing()
                
            case .failure(let error):
                
                print(error)
            }
        }
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
        
        trainingResultPage.dataSource = self
        
        trainingResultPage.loadViewIfNeeded()
        
        fetchTrainingResult()
        
        showTrainingResultPage()
    }
    
    private func showTrainingResultPage() {
        
        postWallView.trainingResultPageView.addSubview(trainingResultPage.view)
        
        trainingResultPage.view.frame = postWallView.trainingResultPageView.bounds
        
        addChild(trainingResultPage)
        
        trainingResultPage.didMove(toParent: self)
    }
}
