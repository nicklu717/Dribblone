//
//  MoveTrackerView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/8/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import AVFoundation

class MoveTrackerView: UIView {
    
    weak var videoOutputDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?
   
    let cameraLayer = AVCaptureVideoPreviewLayer()
    
    let captureSession = AVCaptureSession()
    
    var cameraView: UIView! {
        
        didSet {
            
            cameraView.frame = bounds
            
            addSubview(cameraView)
        }
    }
    
    var cancelButton: UIButton! {
    
        didSet {
            
            cancelButton.setImage(UIImage(named: "close"), for: .normal)
            cancelButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            
            cancelButton.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
            
            cancelButton.layer.cornerRadius = 10
            cancelButton.clipsToBounds = true
            
            cancelButton.frame = CGRect(x: 55, y: 25, width: 45, height: 45)
            
            addSubview(cancelButton)
        }
    }
    
    var startButton: UIButton! {
        
        didSet {
            
            startButton.setTitle("START", for: .normal)
            startButton.setTitleColor(UIColor(white: 0.8, alpha: 1), for: .normal)
            startButton.titleLabel?.font = UIFont.systemFont(ofSize: 55)
            
            startButton.backgroundColor = UIColor(white: 0.2, alpha: 1)
            
            startButton.layer.cornerRadius = 10
            startButton.clipsToBounds = true
            
            addSubview(startButton)
            
            startButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
            ])
        }
    }
    
    var timerLabel: UILabel! {
        
        didSet {
            
            timerLabel.textColor = UIColor(white: 0.8, alpha: 1)
            timerLabel.font = UIFont(name: "Helvetica Neue", size: 55)
            
            timerLabel.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
            
            timerLabel.layer.cornerRadius = 10
            timerLabel.clipsToBounds = true
            
            addSubview(timerLabel)
            
            timerLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                timerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25),
                timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55)
            ])
        }
    }
    
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        
        initializeSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        initializeSubviews()
    }
    
    func initializeSubviews() {
        
        cameraView = UIView()
        
        cancelButton = UIButton()
        startButton = UIButton()
        timerLabel = UILabel()
        
        setUpCaptureSession()
        
        setUpCameraLayer()
    }
    
    private func setUpCaptureSession() {
        
        // Set Session Input
        
        guard
            let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                 for: .video,
                                                 position: .back),
            let cameraInput = try? AVCaptureDeviceInput(device: camera)
            else {
                print("Couldn't Set Up Camera Input")
                return
        }
        
        captureSession.addInput(cameraInput)
        
        // Set Session Output
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        
        let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput")
        
        videoDataOutput.setSampleBufferDelegate(self.videoOutputDelegate,
                                                queue: videoDataOutputQueue)
        
        captureSession.addOutput(videoDataOutput)
    }
    
    private func setUpCameraLayer() {
        
        cameraLayer.session = captureSession
        
        cameraLayer.frame = cameraView.bounds
        
        cameraLayer.videoGravity = .resizeAspectFill
        
        cameraView.layer.addSublayer(cameraLayer)
    }
}
