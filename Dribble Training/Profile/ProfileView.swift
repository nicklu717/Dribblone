//
//  ProfileView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/11.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate: UIViewController {
    
    func showTrainingHistory()
}

class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    
    @IBAction func showTrainingHistory() {
        delegate?.showTrainingHistory()
    }
}
