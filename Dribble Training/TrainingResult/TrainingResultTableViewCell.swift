//
//  TrainingResultTableViewCell.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/9.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import AVKit

class TrainingResultTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var modeLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var videoView: UIView!
    @IBOutlet var playVideoButton: UIButton!
    
    var videoDownloadURL: String?
    
    var isVideoAvailable = true
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width * 1/2
    }
    
    @IBAction func playVideo() {
        
        playVideoButton.isHidden = true
        
        guard
            let videoDownloadURL = videoDownloadURL
            else {
                print("Video Download URL Not Exist")
                return
        }
        
//        delegate?.playVideo(from: videoDownloadURL) { result in
//            
//            switch result {
//                
//            case .success:
//                
//                self.playVideoButton.isHidden = false
//                
//            case .failure(let error):
//                
//                print(error)
//                
//                self.isVideoAvailable = false
//            }
//        }
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        if !isVideoAvailable {
            
            playVideoButton.setTitle("Video Not Available", for: .normal)
        }
    }
}
