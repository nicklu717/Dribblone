//
//  ProfileViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/11.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileView: ProfileView!
    
    var member: Member?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard
            let member = member
            else {
                print("Member Not Exist")
                return
        }
        
        navigationItem.title = member.id
        
        profileView.setupProfile(for: member)
        
        profileView.setupTrainingResultPage(for: member)
    }
}
