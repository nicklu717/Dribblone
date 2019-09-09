//
//  TrainingResultViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import Photos

class TrainingResultViewController: UIViewController {
    
    var trainingResults: [TrainingResult] = []
    
    @IBOutlet var trainingResultView: TrainingResultView! {
        didSet {
            trainingResultView.delegate = self
        }
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
            return TrainingResultTableViewCell()
        }
        
        let result = trainingResults[indexPath.row]
        
        cell.dateLabel.text = "\(result.date)"
        cell.modeLabel.text = result.mode
        cell.pointsLabel.text = "\(result.points) pts"
        
        if let videoLocalID = result.videoLocalID {
            
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [videoLocalID], options: nil)

            PHImageManager.default().requestPlayerItem(
                forVideo: fetchResult.object(at: 0),
                options: nil) { (playerItem, _) in
                    
                    let avPlayer = AVPlayer(playerItem: playerItem)
                    
                    let avPlayerLayer = AVPlayerLayer(player: avPlayer)
                    
                    avPlayerLayer.videoGravity = .resizeAspect
                    
                    DispatchQueue.main.async {
                        
                        avPlayerLayer.frame = cell.videoView.bounds
                        
                        cell.videoView.layer.addSublayer(avPlayerLayer)
                    }
            }
        }
        
        return cell
    }
}
