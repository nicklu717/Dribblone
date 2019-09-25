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
    
    @IBOutlet var profileView: ProfileView! {
        didSet {
            profileView.delegate = self
        }
    }
    
    var member: Member! {
        
        didSet {
            
            setupProfileView()
            setupTrainingResultPage()
        }
    }
    
    var isOtherUser: Bool = false
    
    private var trainingResultPage: TrainingResultViewController!
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if isOtherUser {
            
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
            
            profileView.followButton.isHidden = false
            profileView.blockButton.isHidden = false
        }
        
        updateFollowingStatus()
    }
    
    // MARK: - Private Method
    
    private func updateFollowingStatus() {
        
        if isFollowing {
            
            profileView.followButton.setTitle("Unfollow", for: .normal)
            
        } else {
            
            profileView.followButton.setTitle("Follow", for: .normal)
        }
    }
    
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
    
    private func showTrainingResultPage() {
        
        profileView.trainingResultPageView.addSubview(trainingResultPage.view)
        
        trainingResultPage.view.frame = profileView.trainingResultPageView.bounds
        
        addChild(trainingResultPage)
        
        trainingResultPage.didMove(toParent: self)
    }
}

extension ProfileViewController: ProfileViewDelegate {
    
    var isFollowing: Bool {
        
        let followings = AuthManager.shared.currentUser.followings
        
        return followings.contains(member.id)
    }
    
    func followUser() {
        
        FirestoreManager.shared.follow(member: member)
        
        AuthManager.shared.currentUser.followings.append(member.id)
        
        updateFollowingStatus()
    }
    
    func unfollowUser() {
        
        FirestoreManager.shared.unfollow(member: member)
        
        let followings = AuthManager.shared.currentUser.followings
        
        var newFollowings: [ID] = []
        
        for id in followings where id != member.id {
            
            newFollowings.append(id)
        }
        
        AuthManager.shared.currentUser.followings = newFollowings
        
        updateFollowingStatus()
    }
    
    func blockUser() {
        
        showConfirmAlert(title: "Block \(member.id)?", confirmHandler: blockUserHandler)
    }
    
    private func blockUserHandler() {
        
        print("BLOCK user")
        
        FirestoreManager.shared.block(member: member)
        
        AuthManager.shared.currentUser.blockList.append(member.id)
        
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileViewController: TrainingResultViewControllerDataSource {
    
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
}
