//
//  ProfileView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/11.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate: UIViewController {
    
    var member: Member? { get }
    
    var trainingResults: [TrainingResult]? { get }
}

class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    
    @IBOutlet var pictureImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var followingsLabel: UILabel!
    @IBOutlet var followersLabel: UILabel!
    
    @IBOutlet var trainingResultPageView: UIView!
    
    var trainingResultPage: TrainingResultViewController!
    
    func setupProfile(for member: Member?) {
        
        guard
            let member = member
            else {
                print("Member Not Exist")
                return
        }
        
//        pictureImageView.image = member.picture
        nameLabel.text = member.id
        followingsLabel.text = member.followings.count.string()
        followersLabel.text = member.followers.count.string()
    }
    
    func setupTrainingResultPage(_ trainingResults: [TrainingResult]) {
        
        let storyboard = UIStoryboard.trainingResult
        
        guard
            let trainingResultViewController = storyboard.instantiateInitialViewController()
                as? TrainingResultViewController
            else {
                print("Training Result View Controller Not Exist")
                return
        }
        
        trainingResultPage = trainingResultViewController
        
        trainingResultPageView.addSubview(trainingResultPage.view)
        
        trainingResultPage.loadViewIfNeeded()
        
        trainingResultPage.trainingResults = trainingResults
    }
}
