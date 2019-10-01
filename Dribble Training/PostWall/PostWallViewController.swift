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
    
    @IBOutlet var postWallView: PostWallView! {
        didSet {
            postWallView.delegate = self
        }
    }
    
    private var trainingResults: [TrainingResult] = [] {
        didSet {
            postWallView.reloadCollectionView()
        }
    }
    
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
                
                self.trainingResults = filteredTrainingResults
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
}

extension PostWallViewController: PostWallViewDelegate {
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        
        return trainingResults.count
    }
    
    func cellForItemAt(_ indexPath: IndexPath,
                       for collectionView: UICollectionView) -> UICollectionViewCell {
        
        let postWallCollectionViewcell =
            collectionView.dequeueReusableCell(withReuseIdentifier: PostWallCollectionViewCell.id,
                                               for: indexPath)
        
        guard let cell = postWallCollectionViewcell as? PostWallCollectionViewCell
            else {
                print("Post Wall Collection View Cell Casting Failure")
                return postWallCollectionViewcell
        }
        
        let result = trainingResults[indexPath.row]
        
        cell.idButton.setTitle(result.id, for: .normal)
        
        cell.pointsLabel.text = String(result.points)
        
        cell.modeLabel.text = result.mode
        
        cell.screenShotImageView.setImage(withURLString: result.screenShot)
        
        cell.videoURL = URL(string: result.videoURL)
        
        StorageManager.shared.getProfilePicture(forID: result.id) { result in
            
            switch result {
                
            case .success(let url):
                
                cell.profileImageView.setImage(withURLString: url.absoluteString,
                                               placeholder: UIImage.asset(.profile))
                
            case .failure(let error):
                
                print(error)
            }
        }
        
        return cell
    }
}
