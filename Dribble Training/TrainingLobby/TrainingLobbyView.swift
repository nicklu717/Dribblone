//
//  TrainingLobbyView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol TrainingLobbyViewDelegate: AnyObject {
    
    func startTraining(mode: TrainingMode)
}

class TrainingLobbyView: UIView {
    
    weak var delegate: TrainingLobbyViewDelegate?
    
    @IBOutlet var randomModeButton: UIButton!
    @IBOutlet var crossoverModeButton: UIButton!
    @IBOutlet var lowModeButton: UIButton!
    
    @IBAction func startTraining(_ button: UIButton) {
        
        switch button {
            
        case randomModeButton: delegate?.startTraining(mode: .random)
            
        case crossoverModeButton: delegate?.startTraining(mode: .crossover)
            
        case lowModeButton: delegate?.startTraining(mode: .low)
            
        default: return
        }
    }
}
