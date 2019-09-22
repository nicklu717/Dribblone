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
    
    func fetchTrainingResults(for member: Member? = nil,
                              completion: (() -> Void)?) {
        
        FirestoreManager.shared.fetchTrainingResult(for: member) { result in
            
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
        
        if
            let urlString = trainingResult.videoURL,
            let url = URL(string: urlString) {
            
            cell.setupAVPlayer(url: url)
        }
        
        return cell
    }
}

