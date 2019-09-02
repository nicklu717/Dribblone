//
//  MoveTrackerView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/8/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import AVFoundation

protocol MoveTrackerViewDelegate: AnyObject {}

class MoveTrackerView: UIView {
    
    weak var delegate: MoveTrackerViewDelegate?
    
    let captureSession = AVCaptureSession()
    
    let cameraView = UIView()
    
    let cameraLayer = AVCaptureVideoPreviewLayer()
}
