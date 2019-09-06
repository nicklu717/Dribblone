//
//  BallTrackerView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/8/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import AVFoundation

class BallTrackerView: UIView {
    
    // MARK: - Property Declaration
    
    weak var videoOutputDelegate: AVCaptureVideoDataOutputSampleBufferDelegate? {
       
        didSet {
            
            setUpCaptureSession()
            
            setUpCameraLayer()
        }
    }
    
    let cameraLayer = AVCaptureVideoPreviewLayer()
    
    let captureSession = AVCaptureSession()
    
    // MARK: - Instance Method
    
    func layoutCameraLayer() {
        
        cameraLayer.frame = bounds
    }
    
    // MARK: - Private Method
    
    private func setUpCaptureSession() {
        
        captureSession.sessionPreset = .high
        
        // Set Session Input
        
        guard
            let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                 for: .video,
                                                 position: .front),
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
        
        cameraLayer.videoGravity = .resizeAspectFill
        
        cameraLayer.connection?.videoOrientation = .landscapeLeft
        
//        layer.insertSublayer(cameraLayer, at: 0)
        
        layer.addSublayer(cameraLayer)
    }
}
