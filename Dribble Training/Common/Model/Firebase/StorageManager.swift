//
//  StorageManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/17.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import FirebaseStorage
import AVFoundation

class StorageManager {
    
    static let shared = StorageManager()
    
    private let storageReference = Storage.storage().reference()
    
    var temporaryLocalStorageURL: URL
    
    init() {
        
        var url = FileManager.default.urls(for: .documentDirectory,
                                           in: .userDomainMask).first!
        
        url.appendPathComponent("temporary_video")
        url.appendPathExtension("mp4")
        print("FILE PATH:", url)
        
        temporaryLocalStorageURL = url
    }
    
    func upload(videoID: String,
                avAsset: AVAsset,
                completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard
            let member = AuthManager.shared.currentUser
            else {
                print("Member Not Exist")
                return
        }
        
        let exportSession = AVAssetExportSession(asset: avAsset,
                                                 presetName: AVAssetExportPreset1920x1080)
        exportSession?.outputFileType = .mp4
        exportSession?.outputURL = temporaryLocalStorageURL
        exportSession?.exportAsynchronously(completionHandler: {
            
            let videoReference =
                self.storageReference
                    .child(member.id)
                    .child(Folder.trainingVideo)
                    .child("\(videoID).mp4")
            
            let metadata = StorageMetadata(dictionary: ["Content-Type": "video/mp4"])
            
            videoReference.putFile(
                from: self.temporaryLocalStorageURL,
                metadata: metadata) { (metadata, error) in
                    
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    videoReference.downloadURL(completion: { (url, error) in
                        
                        if let error = error {
                            completion(.failure(error))
                        }
                        
                        if let url = url {
                            completion(.success(url))
                        }
                    })
            }
        })
        
//        videoReference.putData(
//            videoData,
//            metadata: nil) { (_, error) in
//
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//
//                videoReference.downloadURL { (url, error) in
//
//                    if let error = error {
//                        completion(.failure(error))
//                    }
//
//                    if let url = url {
//                        completion(.success(url))
//                    }
//                }
//        }
    }
    
//    func downloadVideo(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
//
//        guard
//            let member = AuthManager.shared.currentUser
//            else {
//                print("Member Not Exist")
//                return
//        }
//
//        let videoReference =
//            Storage.storage().reference(forURL: urlString).getData(maxSize: 10*1024*1024) { (data, error) in
//
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//
//                if let data = data {
//                    completion(.success(data))
//                    return
//                }
//        }
//    }
    
    
    
    private struct Folder {
        
        static let trainingVideo = "training_video"
    }
}
