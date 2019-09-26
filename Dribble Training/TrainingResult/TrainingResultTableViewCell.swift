//
//  TrainingResultTableViewCell.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/9.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import AVKit

protocol TrainingResultTableViewCellDelegate: UIViewController {
    
    func pushProfile(forID memberID: ID)
}

class TrainingResultTableViewCell: UITableViewCell {
    
    weak var delegate: TrainingResultTableViewCellDelegate?
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var idButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var modeLabel: UILabel!
    
    @IBOutlet var pointsLabel: UILabel!
    
    @IBOutlet var videoView: UIImageView!
    @IBOutlet var playVideoButton: UIButton!
    
    var videoURL: URL?
    
    var isVideoAvailable = true
    
    var isVideoSet = false
    
    let avPlayerLayer = AVPlayerLayer()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width * 1/2
        
        profileImageView.image = UIImage.asset(.profile)
        
        avPlayerLayer.frame = videoView.bounds
        
        avPlayerLayer.videoGravity = .resizeAspectFill
        
        videoView.layer.addSublayer(avPlayerLayer)
    }
    
    @IBAction func playVideo() {
        
        playVideoButton.isHidden = true
        
        if !isVideoSet {
            
            if let url = videoURL {
                setupAVPlayer(url: url)
            }
        }
        
        avPlayerLayer.player?.play()
    }
    
    @IBAction func pushProfile() {
        
        delegate?.pushProfile(forID: idButton.titleLabel?.text ?? "")
    }
    
    private func setupAVPlayer(url: URL) {
        
        let playerItem = AVPlayerItem(url: url)
        
        let avPlayer = AVPlayer(playerItem: playerItem)
        
        avPlayerLayer.player = avPlayer
        
        let endTime = playerItem.asset.duration
        
        avPlayer.addBoundaryTimeObserver(
            forTimes: [NSValue(time: endTime)],
            queue: DispatchQueue.main,
            using: {
                
                self.avPlayerLayer.player?.seek(to: .zero)
                
                self.playVideoButton.isHidden = false
        })
        
        isVideoSet = true
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        if isVideoAvailable {
            
            avPlayerLayer.player = nil
            isVideoSet = false
            
            playVideoButton.isHidden = false
            
            playVideoButton.setTitle(nil, for: .normal)
            playVideoButton.setImage(UIImage.asset(.play), for: .normal)
            
        } else {
            
            playVideoButton.setTitle("Video Not Available", for: .normal)
            playVideoButton.setImage(nil, for: .normal)
        }
    }
}
