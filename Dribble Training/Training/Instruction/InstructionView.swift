//
//  InstructionView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/10/3.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol InstructionViewDelegate: AnyObject {
    
    func startTraining()
}

class InstructionView: UIView {
    
    weak var delegate: InstructionViewDelegate?
    
    @IBAction func startTraining() {
        
        delegate?.startTraining()
    }
}
