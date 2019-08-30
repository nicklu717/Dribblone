//
//  MovementTrackerViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/8/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import AVFoundation

class MovementTrackerViewController: UIViewController {
    
    // MARK: - Property Declaration
    
    @IBOutlet var movementTrackerView: MovementTrackerView! {
        
        didSet {
            
            movementTrackerView.delegate = self
        }
    }
    
//    // MARK: - View Life Cycle
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//
//
//    }
    
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
        
        movementTrackerView.captureSession.addInput(cameraInput)
        
        // Set Session Output
        let videoDataOutput = AVCaptureVideoDataOutput()
        
        let videoDataOutputQueue = DispatchQueue(label: "Video Data Output")
        
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        movementTrackerView.captureSession.addOutput(videoDataOutput)
    }
}

extension MovementTrackerViewController: MovementTrackerViewDelegate {}

extension MovementTrackerViewController: AVCaptureVideoDataOutputSampleBufferDelegate {}
