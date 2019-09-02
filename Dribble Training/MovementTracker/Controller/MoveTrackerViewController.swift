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
    
    var minute: Int!
    var second: Int! {
        
        didSet {

            moveTrackerView.timerLabel.text = String(format: "%02d:%02d",
                                                     minute, second)
        }
    }
    
    var timer: Timer?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {

        super.viewDidLoad()

        setUpCaptureSession()
        
        moveTrackerView.setUpCameraLayer()
        
        moveTrackerView.layoutCameraView()
        
        moveTrackerView.addCancelButton()
        
        moveTrackerView.addStartButton()
        
        moveTrackerView.startButton.addTarget(self,
                                              action: #selector(startTimer),
                                              for: .touchUpInside)
        
        moveTrackerView.addTimerLabel()
        
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
}

extension MoveTrackerViewController: MoveTrackerViewDelegate {}

extension MoveTrackerViewController: AVCaptureVideoDataOutputSampleBufferDelegate {}
