//
//  MovementTrackerView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/8/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import AVFoundation

protocol MovementTrackerViewDelegate: AnyObject, AVCaptureVideoDataOutputSampleBufferDelegate {}

class MovementTrackerView: UIView {
    
    // MARK: - Property Declaration
    
    weak var delegate: MovementTrackerViewDelegate?
    
    private let captureSession = AVCaptureSession()
    
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
        
        captureSession.addInput(cameraInput)
        
//        // Set Session Output
//
//        let videoDataOutput = AVCaptureVideoDataOutput()
//
//        let videoDataOutputQueue = DispatchQueue(label: "Video Data Output")
//
//        videoDataOutput.setSampleBufferDelegate(self.delegate, queue: videoDataOutputQueue)
//
//        captureSession.addOutput(videoDataOutput)
    }
}
