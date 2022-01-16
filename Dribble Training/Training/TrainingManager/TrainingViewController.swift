//
//  TrainingViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/8/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import ReplayKit

class TrainingViewController: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    // MARK: - Property Declaration
    var ballTrackerPage: BallTrackerViewController! {
        didSet { ballTrackerPage.delegate = self }
    }
    
    var trainingAssistantPage: TrainingAssistantViewController! {
        didSet { trainingAssistantPage.delegate = self }
    }
    
    let screenRecorder = RPScreenRecorder.shared()
    
    var pixelBuffer: CVPixelBuffer?
    
    var trainingResult: TrainingResult!
    
    // MARK: - Instance Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        switch destination {
        case is BallTrackerViewController:
            ballTrackerPage = destination as? BallTrackerViewController
        case is TrainingAssistantViewController:
            trainingAssistantPage = destination as? TrainingAssistantViewController
        default: return
        }
    }
    
    func setTrainingMode(to mode: TrainingMode) {
        trainingAssistantPage.trainingMode = mode
    }
    
    // MARK: - Private Method
    private func takeScreenShot() {
        guard let pixelBuffer = pixelBuffer else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let image = UIImage(ciImage: ciImage, scale: 1, orientation: .upMirrored)
        let fileName = String(format: "%.0d", trainingResult.date)
        StorageManager.default.uploadScreenShot(
            fileName: fileName,
            image: image) { (result) in
                switch result {
                case .success(let url):
                    self.trainingResult.screenShot = String(describing: url)
                case .failure(let error):
                    print(error)
                }
        }
    }
}

extension TrainingViewController: BallTrackerViewControllerDelegate {
    
    func didGetBallPosition(_ position: CGPoint) {
        trainingAssistantPage.setBallNode(to: position)
    }
}

extension TrainingViewController: TrainingAssistantViewControllerDelegate {
    
    func startRecording() {
        screenRecorder.startRecording { error in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    func restartRecording() {
        if screenRecorder.isRecording {
            cancelRecording()
            restartRecording()
            return
        }
        
        screenRecorder.startRecording { error in
            if let error = error {
                print(error)
                return
            }
        }
        
        guard let currentUser = AuthManager.default.currentUser else { return }
        
        let date = Date().timeIntervalSince1970
        
        trainingResult = TrainingResult(id: currentUser.id,
                                        date: date,
                                        mode: .empty,
                                        points: 0,
                                        videoURL: .empty,
                                        screenShot: .empty)
        
        takeScreenShot()
    }
    
    func cancelRecording() {
        screenRecorder.stopRecording(handler: nil)
    }
    
    func endTraining(points: Int, trainingMode mode: String) {
        trainingResult.mode = mode
        trainingResult.points = points
        screenRecorder.stopRecording { (previewViewController, error) in
            if let error = error {
                print(error)
                return
            }
            guard let previewViewController = previewViewController else { return }
            previewViewController.previewControllerDelegate = self
            self.present(previewViewController, animated: true)
        }
    }
}

extension TrainingViewController: RPPreviewViewControllerDelegate {
    
    func previewController(_ previewController: RPPreviewViewController,
                           didFinishWithActivityTypes activityTypes: Set<String>) {
        if !activityTypes.contains(UIActivity.ActivityType.saveToCameraRoll.rawValue) {
            let fileName = String(format: "%.0d", trainingResult.date)
            StorageManager.default.removeScreenShot(fileName: fileName)
            presentingViewController?.dismiss(animated: true)
            return
        }
        
        guard let currentUser = AuthManager.default.currentUser else {
            presentingViewController?.dismiss(animated: true)
            return
        }
        
        guard let videoResource = PhotosManager.default.fetchResource(for: .video) else {
                presentingViewController?.dismiss(animated: true)
                return
        }
        
        var temporaryURL = FileManager.default.temporaryDirectory
        temporaryURL.appendPathComponent("temp")
        temporaryURL.appendPathExtension("mp4")
        PhotosManager.default.writeData(to: temporaryURL, resource: videoResource) {
            StorageManager.default.uploadVideo(
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
                        self.presentingViewController?.dismiss(animated: true)
                        FirestoreManager.default.upload(trainingResult: self.trainingResult, for: currentUser)
                    case .failure(let error):
                        print(error)
                    }
            })
        }
    }
}
