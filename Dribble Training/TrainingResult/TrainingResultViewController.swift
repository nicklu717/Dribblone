//
//  TrainingResultViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import AVKit

class TrainingResultViewController: UIViewController {
    
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
    
//    let photoManager = PhotoManager.shared
    
    let firestoreManager = FirestoreManager.shared
    
    let storageManager = StorageManager.shared
    
    let avPlayerViewController = AVPlayerViewController()
    
    func fetchTrainingResults(for member: Member?,
                              completion: (() -> Void)?) {
        
        firestoreManager.fetchTrainingResult(for: member) { result in
            
            switch result {
                
            case .success(let trainingResults):
                
                self.trainingResults = trainingResults
                
            case .failure(let error):
                
                print(error)
            }
            
            completion?()
        }
    }
}

extension TrainingResultViewController: TrainingResultViewDataSource {

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
        
        let trainingResult = trainingResults[indexPath.row]
        
        let date = Date(timeIntervalSince1970: trainingResult.date)
        
        cell.dateLabel.text = date.string(format: .resultDisplay)
        
        cell.idLabel.text = trainingResult.id
        cell.modeLabel.text = trainingResult.mode
        cell.pointsLabel.text = "\(trainingResult.points) pts"
        
        if let urlString = trainingResult.videoURL, let url = URL(string: urlString) {
            
            let playerItem = AVPlayerItem(url: url)
            
            let avPlayer = AVPlayer(playerItem: playerItem)
            
            cell.avPlayerLayer.player = avPlayer
            
            let endTime = playerItem.asset.duration
            
            avPlayer.addBoundaryTimeObserver(
                forTimes: [NSValue(time: endTime)],
                queue: DispatchQueue.main,
                using: {

                    cell.avPlayerLayer.player?.seek(to: .zero)

                    cell.playVideoButton.isHidden = false
            })
        }
        
        return cell
    }
}

