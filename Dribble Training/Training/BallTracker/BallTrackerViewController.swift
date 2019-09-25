//
//  BallTrackerViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/6.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

protocol BallTrackerViewControllerDelegate: AnyObject {
    
    func didGetBallPosition(_ position: CGPoint)
}

class BallTrackerViewController: UIViewController {
    
    // MARK: - Property Declaration
    
    weak var delegate: BallTrackerViewControllerDelegate?
    
    @IBOutlet var ballTrackerView: BallTrackerView! {
        didSet {
            ballTrackerView.videoOutputDelegate = self
        }
    }
    
    var coreMLModel: VNCoreMLModel!
    
    let sequenceRequestHandler = VNSequenceRequestHandler()
    
//    var detectionStatistic: [String: Int] = [:]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        do {
            
            coreMLModel = try VNCoreMLModel(for: MobileNetV2_SSDLite().model)
            
        } catch {
            
            fatalError("Unresolve Error: \(error), \(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        ballTrackerView.captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        ballTrackerView.captureSession.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        ballTrackerView.layoutCameraLayer()
    }
    
    // MARK: - Private Method
    
    private func coreMLRequestCompletion(request: VNRequest, error: Error?) {
        
        guard let observations = request.results as? [VNRecognizedObjectObservation], observations.count > 0
            else {
                return
        }
        
        for observation in observations {
            
            guard let objectID = observation.labels.first?.identifier
                else {
                    print("First Label Not Exist")
                    return
            }
            
//            detectionStatistic[objectID] = (detectionStatistic[objectID] ?? 0) + 1
            
            // Get Detected Object Position
            
            switch objectID {
                
            case "sports ball", "mouse", "clock", "donut", "kite":
                
                let visionRect = observation.boundingBox
                
                var avFoundationRect = visionRect
                
                avFoundationRect.origin.y = 1 - (visionRect.origin.y + visionRect.height)
                
                let cameraLayer = ballTrackerView.cameraLayer
                
                let layerRect = cameraLayer.layerRectConverted(fromMetadataOutputRect: avFoundationRect)
                
                self.delegate?.didGetBallPosition(layerRect.center())
                
            default: return
            }
        }
    }
}

extension BallTrackerViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
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
