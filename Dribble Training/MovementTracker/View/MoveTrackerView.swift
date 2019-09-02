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
    
    func setUpCameraLayer() {
        
        cameraLayer.session = captureSession
        
        cameraView.layer.addSublayer(cameraLayer)
        
        addSubview(cameraView)
    }
    
    func layoutCameraView() {
        
        cameraView.frame = bounds
        
        cameraLayer.frame = cameraView.bounds
        
        cameraLayer.videoGravity = .resizeAspectFill
    }
    
    func addCancelButton() {
        
        let button = UIButton()
        
        button.setImage(UIImage(named: "close"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        button.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        button.frame = CGRect(x: 55, y: 25, width: 45, height: 45)
        
        addSubview(button)
    }
    
    func addStartButton() {
        
        let startButton = UIButton()
        
        startButton.setTitle("START", for: .normal)
        startButton.setTitleColor(UIColor(white: 0.8, alpha: 1), for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 55)
        
        startButton.backgroundColor = UIColor(white: 0.2, alpha: 1)
        
        startButton.layer.cornerRadius = 10
        startButton.clipsToBounds = true
        
//        startButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        
        addSubview(startButton)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ])
    }
}
