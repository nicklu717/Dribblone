//
//  InstructionView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/10/3.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

protocol InstructionViewDelegate: AnyObject {
    
    func startTraining()
    
    func dismiss()
}

class InstructionView: UIView {
    
    // MARK: - Property
    
    weak var delegate: InstructionViewDelegate?
    
    @IBOutlet var dismissButton: UIButton! {
        
        didSet {
            
            let inset: CGFloat = 5
            
            dismissButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset,
                                                         bottom: inset, right: inset)
        }
    }
    
    @IBOutlet var videoPlayerView: YTPlayerView!
    @IBOutlet var modeLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    // MARK: - Instance Method
    
    @IBAction func startTraining() {
        
        delegate?.startTraining()
    }
    
    @IBAction func dismiss() {
        
        delegate?.dismiss()
    }
}
