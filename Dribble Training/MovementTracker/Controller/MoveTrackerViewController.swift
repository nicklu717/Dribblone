//
//  MoveTrackerViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/8/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class MoveTrackerViewController: UIViewController {
    
    // MARK: - Property Declaration
    
    @IBOutlet var moveTrackerView: MoveTrackerView! {
        
        didSet {
            
            moveTrackerView.videoOutputDelegate = self
        }
    }
    
    var minute: Int!
    var second: Int! {
        
        didSet {

            moveTrackerView.timerLabel.text = String(format: "%02d:%02d",
                                                     minute, second)
        }
    }
    
    var timer: Timer?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    var coreMLModel: VNCoreMLModel!
    
    let sequenceRequestHandler = VNSequenceRequestHandler()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {

        super.viewDidLoad()
        
        do {
            coreMLModel = try VNCoreMLModel(for: MobileNetV2_SSDLite().model)
        } catch {
            print(error)
        }
        
        moveTrackerView.startButton.addTarget(self,
                                              action: #selector(startTimer),
                                              for: .touchUpInside)
        
        setTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        moveTrackerView.captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        moveTrackerView.captureSession.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        moveTrackerView.layoutCameraView()
    }
    
    // MARK: - Method
    
    func setTimer(minute: Int = 0, second: Int = 10) {
        
        self.minute = minute
        self.second = second
    }
    
    @objc func startTimer() {
        
        moveTrackerView.startButton.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(countDown),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func countDown() {
        
        if second == 0 {
            
            if minute > 0 {
                
                minute -= 1
                second = 60
                
            } else {
                
                print("Time's Up")
                
                timer?.invalidate()
                
                return
            }
        }
        
        second -= 1
    }
    
    private func coreMLRequestCompletion(request: VNRequest, error: Error?) {}
}

extension MoveTrackerViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        guard

            let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)

        else {

            print("Sample Buffer Convert Failure")
            return
        }

        let coreMLRequest = VNCoreMLRequest(model: coreMLModel,
                                            completionHandler: coreMLRequestCompletion(request:error:))
        
        do {
            
            try sequenceRequestHandler.perform([coreMLRequest], on: pixelBuffer)
            
        } catch {
            
            print(error)
        }
    }
}
