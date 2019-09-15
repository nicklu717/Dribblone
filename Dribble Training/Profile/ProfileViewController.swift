//
//  ProfileViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/11.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ProfileViewDelegate {
    
    @IBOutlet var profileView: ProfileView!
    
    var member: Member?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        member = Member(id: "wein7", email: "nick@appworks.com", followers: ["a", "b"], followings: ["c", "d", "e"], trainingResults: [TrainingResult(id: "wein7", date: 1234567899, mode: "Test", points: 99, videoLocalID: "Null")], picture: "1234")
        
        profileView.delegate = self
    }
    
    // MARK: - Private Method
    
    
}
