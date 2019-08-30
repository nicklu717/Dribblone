//
//  MovementTrackerView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/8/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import AVFoundation

protocol MovementTrackerViewDelegate: AnyObject {}

class MovementTrackerView: UIView {
    
    weak var delegate: MovementTrackerViewDelegate?
    
    let captureSession = AVCaptureSession()
}
