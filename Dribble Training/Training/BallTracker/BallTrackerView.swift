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
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        
        do {
            
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            
            captureSession.addInput(cameraInput)
            
            let videoDataOutput = AVCaptureVideoDataOutput()
            
            let videoDataOutputQueue = DispatchQueue.global()
            
            videoDataOutput.setSampleBufferDelegate(self.videoOutputDelegate, queue: videoDataOutputQueue)
            
            captureSession.addOutput(videoDataOutput)
        
        } catch {
            
            print(error)
        }
    }
    
    private func setUpCameraLayer() {
        
        cameraLayer.session = captureSession
        
        cameraLayer.videoGravity = .resizeAspectFill
        
        cameraLayer.connection?.videoOrientation = .landscapeLeft
        
        layer.addSublayer(cameraLayer)
    }
}
