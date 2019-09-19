//
//  TrainingResultTableViewCell.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/9.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import AVKit

protocol TrainingResultTableViewCellDelegate: AnyObject {
    
    func playVideo(from url: String, completion: (Result<String, Error>) -> Void)
}

class TrainingResultTableViewCell: UITableViewCell {
    
    weak var delegate: TrainingResultTableViewCellDelegate?
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var modeLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var videoView: UIView!
    @IBOutlet var playVideoButton: UIButton!
    
    var videoDownloadURL: String?
    
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
        
        delegate?.playVideo(from: videoDownloadURL) { result in
            
            switch result {
                
            case .success:
                
                playVideoButton.isHidden = false
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
//        cell.playVideoButton.setTitle("Video Not Available", for: .normal)
    }
}
