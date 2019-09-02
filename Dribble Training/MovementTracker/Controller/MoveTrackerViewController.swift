//
//  MoveTrackerViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/8/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import AVFoundation

class MoveTrackerViewController: UIViewController {
    
    // MARK: - Property Declaration
    
    @IBOutlet var moveTrackerView: MoveTrackerView! {
        
        didSet {
            
            moveTrackerView.delegate = self
        }
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpCaptureSession()
        
        setUpCameraLayer()
        
//        layoutCameraView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        moveTrackerView.captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        moveTrackerView.captureSession.stopRunning()
    }
    
    // MARK: - Private Method
    
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
        
        moveTrackerView.captureSession.addInput(cameraInput)
        
        // Set Session Output
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        
        let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput")
        
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        moveTrackerView.captureSession.addOutput(videoDataOutput)
    }
    
    private func setUpCameraLayer() {
        
        moveTrackerView.cameraLayer.session = moveTrackerView.captureSession
        
        moveTrackerView.cameraView.layer.addSublayer(moveTrackerView.cameraLayer)
        
        moveTrackerView.addSubview(moveTrackerView.cameraView)
    }
    
//    private func layoutCameraView() {
//
//        moveTrackerView.cameraView.frame = moveTrackerView.bounds
//
//        moveTrackerView.cameraLayer.frame = moveTrackerView.cameraView.bounds
//
//        moveTrackerView.cameraLayer.videoGravity = .resizeAspectFill
//    }
}

extension MoveTrackerViewController: MoveTrackerViewDelegate {}

extension MoveTrackerViewController: AVCaptureVideoDataOutputSampleBufferDelegate {}
