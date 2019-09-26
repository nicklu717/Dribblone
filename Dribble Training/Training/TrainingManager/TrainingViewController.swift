//
//  TrainingViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/8/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import ReplayKit
import Photos

class TrainingViewController: UIViewController {
    
    // View Orientation
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    // MARK: - Property Declaration
    
    var ballTrackerPage: BallTrackerViewController! {
        didSet {
            ballTrackerPage.delegate = self
        }
    }
    
    var trainingAssistantPage: TrainingAssistantViewController! {
        didSet {
            trainingAssistantPage.delegate = self
        }
    }
    
    let screenRecorder = RPScreenRecorder.shared()
    
    let imageManager = PHImageManager.default()
    
    let storageManager = StorageManager.shared
    
    let firestoreManager = FirestoreManager.shared
    
    let authManager = AuthManager.shared
    
    var trainingResult: TrainingResult!
    
    var trainingCompletion: ((TrainingResult) -> ())?
    
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
        
        let destination = segue.destination
        
        switch destination  {

        case is BallTrackerViewController:
            
            ballTrackerPage = destination as? BallTrackerViewController
            
        case is TrainingAssistantViewController:
            
            trainingAssistantPage = destination as? TrainingAssistantViewController
            
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
    
    func setTrainingMode(to mode: TrainingMode) {
        
        trainingAssistantPage.trainingMode = mode
    }
}

extension TrainingViewController: BallTrackerViewControllerDelegate {
    
    func didGetBallPosition(_ position: CGPoint) {
        
        trainingAssistantPage.setBallNode(to: position)
    }
}

extension TrainingViewController: TrainingAssistantViewControllerDelegate {
    
    func endTraining(points: Int, trainingMode mode: String) {
        
        guard
            let member = AuthManager.shared.currentUser
            else {
                print("Member Not Exist")
                return
        }
        
        let date = Date().timeIntervalSince1970
        
        trainingResult = TrainingResult(id: member.id,
                                        date: date,
                                        mode: mode,
                                        points: points,
                                        videoURL: nil)
        
        screenRecorder.stopRecording { (previewViewController, error) in
            
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

extension TrainingViewController: RPPreviewViewControllerDelegate {
    
    func previewController(_ previewController: RPPreviewViewController,
                           didFinishWithActivityTypes activityTypes: Set<String>) {
        
        if !activityTypes.contains(UIActivity.ActivityType.saveToCameraRoll.rawValue) {
            
            presentingViewController?.dismiss(animated: true, completion: nil)
            return
        }
        
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        
        guard
            let videoPHAsset = fetchResult.firstObject,
            let videoResource = PHAssetResource.assetResources(for: videoPHAsset).first
        else {
            print("Video Fetching Failure")
            return
        }
        
        var temporaryURL = FileManager.default.temporaryDirectory
        
        temporaryURL.appendPathComponent("temp")
        temporaryURL.appendPathExtension("mp4")
        
        PHAssetResourceManager.default().writeData(
            for: videoResource,
            toFile: temporaryURL,
            options: nil) { error in
                
                if let error = error {
                    print(error)
                    return
                }
                
                self.storageManager.uploadVideo(
                    fileName: videoResource.originalFilename,
                    url: temporaryURL,
                    completion: { result in
                        
                        do {
                            try FileManager.default.removeItem(at: temporaryURL)
                        } catch {
                            print(error)
                        }
                        
                        switch result {
                            
                        case .success(let videoURL):
                            
                            self.trainingResult.videoURL = String(describing: videoURL)
                            
                            self.presentingViewController?.dismiss(animated: true) {
                                
                                self.trainingCompletion?(self.trainingResult)
                            }
                            
                            guard let member = self.authManager.currentUser
                                else {
                                    print("Member Not Exist. Training Result Won't Upload.")
                                    return
                            }
                            
                            self.firestoreManager.upload(trainingResult: self.trainingResult,
                                                         for: member)
                            
                        case .failure(let error):
                            
                            print(error)
                        }
                })
        }
    }
}
