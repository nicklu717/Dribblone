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
    
    private let memberManager = MemberManager.shared
    
    private let databaseManager = DatabaseManager.shared
    
    var member: Member? {
        didSet {
            profileView.setupProfile(for: member)
            fetchTrainingResult()
        }
    }
    
    var trainingResults: [TrainingResult]?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileView.delegate = self
        
        member = memberManager.currentUser
    }
    
    // MARK: - Private Method
    
    private func fetchTrainingResult() {
        
        guard
            let member = member
            else {
                print("Invalid Member")
                return
        }
        
        databaseManager.fetchTrainingResult(forMemberID: member.id) { result in
            
            switch result {
                
            case .success(let trainingResults):
                
                self.profileView.setupTrainingResultPage(trainingResults)
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
}
