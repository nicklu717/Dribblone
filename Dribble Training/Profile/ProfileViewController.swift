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
        
        didSet { profileView.delegate = self }
    }
    
    var member: Member! {
        
        didSet {
        
            setupProfile()
            
            fetchTrainingResult()
        }
    }
    
    var trainingResults: [TrainingResult] = [] {
        
        didSet { profileView.reloadTableView() }
    }
    
    var isOtherUser: Bool {
        
        guard let currentUser = AuthManager.shared.currentUser else { return true }
        
        return member.id != currentUser.id
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if isOtherUser {
            
            navigationItem.leftBarButtonItem = nil
            
            navigationItem.rightBarButtonItem = nil
            
            profileView.followButton.isHidden = false
            
            profileView.blockButton.isHidden = false
            
            updateFollowingStatus()
        }
    }
    
    // MARK: - Private Method
    
    private func setupProfile() {
        
        navigationItem.title = member.id
        
        loadViewIfNeeded()
        
        profileView.setupProfile(for: member)
    }
    
    func fetchTrainingResult() {
        
        FirestoreManager.shared.fetchTrainingResult(for: member) { result in
            
            switch result {
                
            case .success(let trainingResults):
                
                self.trainingResults = trainingResults
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    private func updateFollowingStatus() {
        
        if isFollowing {
            
            profileView.followButton.setTitle("Following", for: .normal)
            
            profileView.followButton.changeBackgroundColor(to: .themeLight, duration: 0.15)
            
        } else {
            
            profileView.followButton.setTitle("Follow", for: .normal)
            
            profileView.followButton.changeBackgroundColor(to: .themeMediumDark, duration: 0.15)
        }
    }
}

extension ProfileViewController: ProfileViewDelegate {
    
    func numberOfRows(inSection section: Int) -> Int {
        
        return trainingResults.count
    }
    
    func cellForRow(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.id, for: indexPath)
        
        guard let resultCell = cell as? ResultTableViewCell else { return cell }
        
        let result = trainingResults[indexPath.row]
        
        let date = Date(timeIntervalSince1970: result.date)
        
        resultCell.dateLabel.text = date.string(format: .resultDisplay)
        
        resultCell.idLabel.text = result.id
        
        resultCell.modeLabel.text = result.mode
        
        resultCell.pointsLabel.text = String(result.points)
        
        resultCell.videoView.setImage(withURLString: result.screenShot)
        
        resultCell.videoURL = URL(string: result.videoURL)
        
        StorageManager.shared.getProfilePicture(forID: result.id) { result in
            
            switch result {
                
            case .success(let url):
                
                resultCell.profileImageView.setImage(withURLString: url.absoluteString,
                                                     placeholder: UIImage.asset(.profile))
                
            case .failure: break
            }
        }
        
        return resultCell
    }
    
    var isFollowing: Bool {
        
        let followings = AuthManager.shared.currentUser?.followings ?? []
        
        return followings.contains(member.id)
    }
    
    func followUser() {
        
        FirestoreManager.shared.follow(member: member)
        
        AuthManager.shared.currentUser?.followings.append(member.id)
        
        updateFollowingStatus()
    }
    
    func unfollowUser() {
        
        FirestoreManager.shared.unfollow(member: member)
        
        var newFollowings: [ID] = []
        
        let followings = AuthManager.shared.currentUser?.followings ?? []
        
        for id in followings where id != member.id {
            
            newFollowings.append(id)
        }
        
        AuthManager.shared.currentUser?.followings = newFollowings
        
        updateFollowingStatus()
    }
    
    func blockUser() {
        
        showConfirmAlert(title: "Block \(member.id)?", confirmHandler: blockUserHandler)
    }
    
    private func blockUserHandler() {
        
        FirestoreManager.shared.block(member: member)
        
        AuthManager.shared.currentUser?.blockList.append(member.id)
        
        navigationController?.popViewController(animated: true)
    }
}
