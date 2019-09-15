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
}

class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate? {
        didSet {
            setupProfile()
            setupTrainingResultPage()
        }
    }
    
    @IBOutlet var pictureImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var followingsLabel: UILabel!
    @IBOutlet var followersLabel: UILabel!
    
    @IBOutlet var trainingResultPageView: UIView!
    
    var trainingResultPage: TrainingResultViewController!
    
    private func setupProfile() {
        
        guard
            let delegate = delegate
            else {
                print("Profile View Delegate Not Exist")
                return
        }
        
//        pictureImageView.image = delegate.member?.
        usernameLabel.text = delegate.member?.id
        followingsLabel.text = delegate.member?.followings.count.string()
        followersLabel.text = delegate.member?.followers.count.string()
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
        
        trainingResultPageView.addSubview(trainingResultPage.view)
        
        trainingResultPage.loadViewIfNeeded()
        
        guard
            let delegate = delegate,
            let member = delegate.member
            else {
                print("Member Info Not Exist")
                return
        }
        
        trainingResultPage.trainingResults = member.trainingResults
    }
}
