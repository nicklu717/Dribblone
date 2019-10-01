//
//  PostWallViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/21.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class PostWallViewController: UIViewController {
    
    // MARK: - Property Declaration
    
    @IBOutlet var postWallView: PostWallView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchTrainingResult()
    }
    
    // MARK: - Private Method
    
    private func fetchTrainingResult() {
        
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
                
                // TODO: Save training results
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
}
