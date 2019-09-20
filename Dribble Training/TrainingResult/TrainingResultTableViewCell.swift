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
    
    var isVideoAvailable = true
    
    let avPlayerLayer = AVPlayerLayer()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width * 1/2
        
        avPlayerLayer.frame = videoView.bounds
        
        videoView.layer.addSublayer(avPlayerLayer)
    }
    
    @IBAction func playVideo() {
        
        playVideoButton.isHidden = true
        
        avPlayerLayer.player?.play()
        
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
        
        if isVideoAvailable {
            
            playVideoButton.isEnabled = true
            playVideoButton.setTitle(nil, for: .normal)
            playVideoButton.setImage(UIImage.asset(.play), for: .normal)
            
        } else {
            
            playVideoButton.isEnabled = false
            playVideoButton.setTitle("Video Not Available", for: .normal)
            playVideoButton.setImage(nil, for: .normal)
        }
    }
}
