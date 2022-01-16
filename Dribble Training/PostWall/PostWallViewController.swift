//
//  PostWallViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/21.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import AVKit

class PostWallViewController: UIViewController {
    
    // MARK: - Property Declaration
    @IBOutlet var postWallView: PostWallView! {
        didSet { postWallView.delegate = self }
    }
    
    private var trainingResults: [TrainingResult] = [] {
        didSet { postWallView.reloadCollectionView() }
    }
    
    let playerViewController = AVPlayerViewController()
    
    var profilePage: ProfileViewController!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTrainingResult()
        setupProfilePage()
    }
    
    // MARK: - Instance Method
    func fetchTrainingResult() {
        FirestoreManager.default.fetchTrainingResult { result in
            switch result {
            case .success(let trainingResults):
                var filteredTrainingResults: [TrainingResult] = []
                if let currentUser = AuthManager.default.currentUser {
                    let blockList = currentUser.blockList
                    for trainingResult in trainingResults {
                        if !blockList.contains(trainingResult.id) {
                            filteredTrainingResults.append(trainingResult)
                        }
                    }
                }
                self.trainingResults = filteredTrainingResults
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Private Method
    private func setupProfilePage() {
        let viewController = UIStoryboard.profile.instantiateViewController(identifier: ProfileViewController.id)
        guard let profilePage = viewController as? ProfileViewController else { return }
        self.profilePage = profilePage
    }
}

extension PostWallViewController: PostWallViewDelegate {
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return trainingResults.count
    }
    
    func cellForItemAt(_ indexPath: IndexPath,
                       for collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.id, for: indexPath)
        guard let resultCell = cell as? ResultCollectionViewCell else { return cell }
        
        let result = trainingResults[indexPath.row]
        resultCell.delegate = self
        resultCell.idButton.setTitle(result.id, for: .normal)
        resultCell.pointsLabel.text = String(result.points)
        resultCell.modeLabel.text = result.mode
        resultCell.screenShotImageView.setImage(withURLString: result.screenShot)
        resultCell.videoURL = URL(string: result.videoURL)
        StorageManager.default.getProfilePicture(forID: result.id) { result in
            switch result {
            case .success(let url):
                resultCell.profileImageView.setImage(withURLString: url.absoluteString,
                                                     placeholder: UIImage.asset(.profile))
            case .failure: break
            }
        }
        return resultCell
    }
}

extension PostWallViewController: ResultCollectionViewCellDelegate {
    
    func showProfile(for id: ID) {
        if let currentUser = AuthManager.default.currentUser {
            if id == currentUser.id { return }
        }
        FirestoreManager.default.fetchMemberData(forID: id) { result in
            switch result {
            case .success(let member):
                guard let member = member else { return }
                self.profilePage.member = member
                self.show(self.profilePage, sender: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func playVideo(with url: URL?) -> Bool {
        guard let url = url else { return false }
        playerViewController.player = AVPlayer(url: url)
        present(playerViewController, animated: true, completion: nil)
        return true
    }
}
