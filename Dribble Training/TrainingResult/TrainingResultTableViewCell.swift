//
//  TrainingResultTableViewCell.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/9.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import AVFoundation

class TrainingResultTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userIDLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var modeLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var videoView: UIView!
    
    let avPlayerLayer = AVPlayerLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avPlayerLayer.frame = videoView.bounds
        
        avPlayerLayer.videoGravity = .resizeAspect
        
        videoView.layer.addSublayer(avPlayerLayer)
    }
}
