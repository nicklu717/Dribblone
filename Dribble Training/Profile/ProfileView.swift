//
//  ProfileView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/11.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    @IBOutlet var pictureImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var followingsLabel: UILabel!
    @IBOutlet var followersLabel: UILabel!
    
    @IBOutlet var trainingResultPageView: UIView!
    
    var trainingResultPage: TrainingResultViewController!
    
    func setupProfile(for member: Member) {
        
//        pictureImageView.image = member.picture
        nameLabel.text = member.displayName
        followingsLabel.text = member.followings.count.string()
        followersLabel.text = member.followers.count.string()
    }
    
    func setupTrainingResultPage(for member: Member) {
        
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
        
        trainingResultPage.fetchTrainingResults(for: member) {
            
            self.showTrainingResults()
        }
    }
    
    private func showTrainingResults() {
        
        trainingResultPageView.addSubview(trainingResultPage.view)
        
        trainingResultPage.view.frame = trainingResultPageView.bounds
    }
}
