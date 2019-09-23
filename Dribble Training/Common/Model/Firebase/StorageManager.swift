//
//  StorageManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/17.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import FirebaseStorage

class StorageManager {
    
    static let shared = StorageManager()
    
    private let storageReference = Storage.storage().reference()
    
    func uploadVideo(fileName: String,
                     url: URL,
                     completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard
            let member = AuthManager.shared.currentUser
            else {
                print("Member Not Exist")
                return
        }
        
        let videoReference =
            self.storageReference
                .child(member.id)
                .child(Folder.trainingVideo)
                .child(fileName)
        
        let metadata = StorageMetadata()
        metadata.contentType = "video/mp4"
        
        videoReference.putFile(
            from: url,
            metadata: metadata) { (_, error) in
                
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
    }
    
    func uploadVideo(fileName: String,
                     data: Data,
                     completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard
            let member = AuthManager.shared.currentUser
            else {
                print("Member Not Exist")
                return
        }
        
        let videoReference =
            self.storageReference
                .child(member.id)
                .child(Folder.trainingVideo)
                .child(fileName)
        
        let metadata = StorageMetadata()
        metadata.contentType = "video/mp4"
        
        videoReference.putData(
            data,
            metadata: metadata,
            completion: { (_, error) in
                
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
        })
    }
    
    private struct Folder {
        
        static let trainingVideo = "training_video"
    }
}
