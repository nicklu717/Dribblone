//
//  ProfileView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/11.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate: AnyObject {
    
    func fetchTrainingResult()
    
    func numberOfRows(inSection section: Int) -> Int
    
    func cellForRow(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell
    
    var isFollowing: Bool { get }
    
    func followUser()
    
    func unfollowUser()
    
    func blockUser()
}

class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var pictureImageView: UIImageView!
    
    @IBOutlet var followingsLabel: UILabel!
    @IBOutlet var followersLabel: UILabel!
    
    @IBOutlet var followButton: UIButton!
    @IBOutlet var blockButton: UIButton!
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    
    func setupProfile(for member: Member) {
        
        StorageManager.shared.getProfilePicture(forID: member.id) { result in
            
            switch result {
                
            case .success(let url):
                
                self.pictureImageView.setImage(withURLString: url.absoluteString,
                                               placeholder: UIImage.asset(.profile))
                
            case .failure: break
            }
        }
        
        nameLabel.text = member.displayName
        followingsLabel.text = String(member.followings.count)
        followersLabel.text = String(member.followers.count)
    }
    
    func reloadTableView() {
        
        tableView.reloadData()
        
        tableView.endHeaderRefresh()
    }
    
    @IBAction func followUser() {
        
        guard let delegate = delegate
            else {
                print("Profile View Delegate Not Exist")
                return
        }
        
        if delegate.isFollowing {
            
            delegate.unfollowUser()
            
        } else {
            
            delegate.followUser()
        }
    }
    
    @IBAction func blockUser() {
        
        delegate?.blockUser()
    }
    
    private func setupTableView() {
        
        tableView.addRefreshHeader { [weak self] in
            
            self?.delegate?.fetchTrainingResult()
        }
        
        tableView.registerCellWithNib(id: ResultTableViewCell.id)
        
        tableView.dataSource = self
    }
}

extension ProfileView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return delegate?.numberOfRows(inSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return delegate?.cellForRow(at: indexPath, in: tableView) ?? UITableViewCell()
    }
}
