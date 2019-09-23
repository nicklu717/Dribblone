//
//  ProfileView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/11.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    @IBOutlet var pictureImageView: UIImageView! {
        didSet {
            pictureImageView.layer.cornerRadius = pictureImageView.bounds.width * 1/2
            pictureImageView.image = UIImage.asset(.profile)
        }
    }
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var followingsLabel: UILabel!
    @IBOutlet var followersLabel: UILabel!
    
    @IBOutlet var followButton: UIButton!
    @IBOutlet var blockButton: UIButton!
    
    @IBOutlet var trainingResultPageView: UIView!
    
    func setupProfile(for member: Member) {
        
//        pictureImageView.image = member.picture
        nameLabel.text = member.displayName
        followingsLabel.text = String(member.followings.count)
        followersLabel.text = String(member.followers.count)
    }
}
