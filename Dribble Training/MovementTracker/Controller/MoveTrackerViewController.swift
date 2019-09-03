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
import ReplayKit

class MoveTrackerViewController: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
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
    
    var coreMLModel: VNCoreMLModel!
    
    let sequenceRequestHandler = VNSequenceRequestHandler()
    
    let recorder = RPScreenRecorder.shared()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {

        super.viewDidLoad()
        
        do {
            coreMLModel = try VNCoreMLModel(for: MobileNetV2_SSDLite().model)
        } catch {
            print(error)
        }
        
        moveTrackerView.startButton.addTarget(self,
                                              action: #selector(startTraining),
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
    
    @objc func startTraining() {
        
        moveTrackerView.startButton.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(countDown),
                                     userInfo: nil,
                                     repeats: true)
        
        recorder.startRecording { error in
            
            if let error = error {
                print(error)
                return
            }
            
            print("Start Recording")
        }
    }
    
    @objc func countDown() {
        
        if second == 0 {
            
            if minute > 0 {
                
                minute -= 1
                second = 60
                
            } else {
                
                timesUp()
            }
        } else {
            
            second -= 1
        }
    }
    
    private func coreMLRequestCompletion(request: VNRequest, error: Error?) {
        
        DispatchQueue.main.async {
            
            self.moveTrackerView.cameraView.subviews.forEach({ $0.removeFromSuperview() })
        }
        
        guard
            let observations = request.results as? [VNRecognizedObjectObservation],
            observations.count > 0
        else {
            return
        }

        for observation in observations {
            
            let visionRect = observation.boundingBox
            
            var avFoundationRect = visionRect
            
            avFoundationRect.origin.y = 1 - (visionRect.origin.y + visionRect.height)
            
            let layerRect
                = moveTrackerView.cameraLayer.layerRectConverted(fromMetadataOutputRect: avFoundationRect)
            
            guard
                
                let firstLabel = observation.labels.first
                
            else {
                
                print("First Label Not Exist")
                
                return
            }
            
            let objectLabel = firstLabel.identifier
            
            DispatchQueue.main.async {
                
                let highlightView = UIView(frame: layerRect)
                
                highlightView.layer.borderColor = UIColor.red.cgColor
                highlightView.layer.borderWidth = 2
                
                let label = UILabel()
                label.text = objectLabel
                label.sizeToFit()
                
                highlightView.addSubview(label)
                
                self.moveTrackerView.cameraView.addSubview(highlightView)
            }
        }
    }
    
    private func timesUp() {
        
        print("Time's Up")
        
        timer?.invalidate()
        
        recorder.stopRecording { [unowned self] (previewViewController, error) in
            
            print("Stop Recording")
            
            if let error = error {
                print(error)
                return
            }
            
            guard let previewViewController = previewViewController else { return }
            
            previewViewController.previewControllerDelegate = self
            
            self.present(previewViewController, animated: true, completion: nil)
        }
    }
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
        
        coreMLRequest.imageCropAndScaleOption = .scaleFill
        
        do {
            
            try sequenceRequestHandler.perform([coreMLRequest], on: pixelBuffer)
            
        } catch {
            
            print(error)
        }
    }
}

extension MoveTrackerViewController: RPPreviewViewControllerDelegate {
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        
        previewController.dismiss(animated: true) {
            
            print("Video End Editing")
        }
    }
}
