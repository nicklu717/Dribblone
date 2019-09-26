//
//  TrainingResultViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol TrainingResultViewControllerDataSource: AnyObject {
    
    func fetchTrainingResult()
}

class TrainingResultViewController: UIViewController {
    
    weak var dataSource: TrainingResultViewControllerDataSource? {
        didSet {
            loadViewIfNeeded()
            trainingResultView.addRefreshHeader()
        }
    }
    
    // MARK: - Property Declaration
    
    @IBOutlet var trainingResultView: TrainingResultView! {
        didSet {
            trainingResultView.delegate = self
        }
    }
    
    var trainingResults: [TrainingResult] = [] {
        didSet {
            trainingResultView.tableView.reloadData()
        }
    }
    
    var profilePage: ProfileViewController!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupProfilePage()
    }
    
    // MARK: - Private Method
    
    private func setupProfilePage() {
        
        let storyboard = UIStoryboard.profile
        
        guard let profilePage = storyboard.instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as? ProfileViewController
            else {
                print("Profile View Controller Not Exist")
                return
        }
        
        self.profilePage = profilePage
    }
    
    func refreshTrainingResult() {
        
        dataSource?.fetchTrainingResult()
    }
    
    func endRefreshing() {
        
        trainingResultView.endHeaderRefresh()
    }
}

extension TrainingResultViewController: TrainingResultViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return trainingResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrainingResultTableViewCell",
                                                     for: indexPath) as? TrainingResultTableViewCell
        else {
            print("Invalid Training Result Table View Cell")
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        let trainingResult = trainingResults[indexPath.row]
        
        let date = Date(timeIntervalSince1970: trainingResult.date)
        
        cell.dateLabel.text = date.string(format: .resultDisplay)
        
        StorageManager.shared.getProfilePicture(forID: trainingResult.id) { result in
            
            switch result {
                
            case .success(let url):
                
                cell.profileImageView.setImage(withURLString: url.absoluteString,
                                               placeholder: UIImage.asset(.profile))
                
            case .failure(let error):
                
                print(error)
            }
        }
        
        cell.idButton.setTitle(trainingResult.id, for: .normal)
        
        cell.modeLabel.text = trainingResult.mode
        
        cell.pointsLabel.text = String(trainingResult.points)
        
        cell.videoView.setImage(withURLString: trainingResult.screenShot)
        
        cell.videoURL = URL(string: trainingResult.videoURL)
        
        return cell
    }
}

extension TrainingResultViewController: TrainingResultTableViewCellDelegate {
    
    func pushProfile(forID memberID: ID) {
        
        if memberID != AuthManager.shared.currentUser.id &&
            memberID != navigationController?.navigationBar.topItem?.title {
        
            FirestoreManager.shared.fetchMemberData(forID: memberID) { result in
                
                switch result {
                    
                case .success(let member):
                    
                    self.profilePage.member = member
                    
                    self.profilePage.isOtherUser = true
                    
                    self.show(self.profilePage, sender: nil)
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
    }
}
