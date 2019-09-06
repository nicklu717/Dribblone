//
//  TrainingManagerViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/8/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import ReplayKit
import Photos

class TrainingManagerViewController: UIViewController {
    
    // View Orientation
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    // MARK: - Property Declaration
    
    var ballTrackerViewController: BallTrackerViewController! {
        didSet {
            ballTrackerViewController.delegate = self
        }
    }
    
    var trainingAssistantViewController: TrainingAssistantViewController! {
        didSet {
            trainingAssistantViewController.delegate = self
        }
    }
    
    let screenRecorder = RPScreenRecorder.shared()
    
    let imageManager = PHImageManager.default()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(startRecording),
            name: .startTraining,
            object: nil
        )
    }
    
    // MARK: - Instance Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationViewController = segue.destination
        
        switch destinationViewController  {

        case is BallTrackerViewController:
            
            ballTrackerViewController =
                (destinationViewController as! BallTrackerViewController)
            
        case is TrainingAssistantViewController:
            
            trainingAssistantViewController =
                (destinationViewController as! TrainingAssistantViewController)
            
        default: return
        }
    }
    
    @objc func startRecording() {
        
        screenRecorder.startRecording { error in
            
            if let error = error {
                print(error)
                return
            }
            
            print("Start Recording")
        }
    }
}

extension TrainingManagerViewController: BallTrackerViewControllerDelegate {
    
    func didGetBallPosition(_ position: CGPoint) {
        trainingAssistantViewController.setBallNode(to: position)
    }
}

extension TrainingManagerViewController: TrainingAssistantViewControllerDelegate {
    
    func endTraining(points: Int, trainingMode: TrainingMode) {
        
        screenRecorder.stopRecording { [unowned self] (previewViewController, error) in
            
            print("Stop Recording")
            
            if let error = error {
                print(error)
                return
            }
            
            guard
                let previewViewController = previewViewController
            else {
                print("Preview View Controller Not Exist")
                return
            }
            
            previewViewController.previewControllerDelegate = self
            
            self.present(previewViewController, animated: true, completion: nil)
        }
    }
}

extension TrainingManagerViewController: RPPreviewViewControllerDelegate {
    
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        
        // TODO: Get Video ID & Save Result into CoreData
        
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        
        guard
            let video = fetchResult.firstObject
        else {
            print("Video Fetching Failure")
            return
        }
        
        print(video.localIdentifier)
        
        previewController.dismiss(animated: true, completion: nil)
    }
    
}
