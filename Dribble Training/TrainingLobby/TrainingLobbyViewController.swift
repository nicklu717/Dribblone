//
//  TrainingLobbyViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class TrainingLobbyViewController: UIViewController, TrainingLobbyViewDelegate {
    
    @IBOutlet var trainingLobbyView: TrainingLobbyView! {
        didSet {
            trainingLobbyView.delegate = self
        }
    }
    
    func startTraining(mode: TrainingMode) {
        
        
    }
}
