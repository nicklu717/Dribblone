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
    
    // MARK: - Property Declaration
    
    private let storageReference = Storage.storage().reference()
    
    // MARK: - Instance Method
    
    func getProfilePicture(forID id: ID, completion: @escaping (Result<URL, Error>) -> Void) {
        
        storageReference
            .child(id)
            .child("profile.jpeg")
            .downloadURL { (url, error) in
                
                if let error = error {
                    completion(.failure(error))
                }
                
                if let url = url {
                    completion(.success(url))
                }
        }
    }
    
    func uploadScreenShot(fileName: String,
                          image: UIImage,
                          completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let data = image.jpegData(compressionQuality: 0.3)
            else {
                print("Screen Shot Image Converting Failure")
                return
        }
        
        let reference =
            self.storageReference
                .child(AuthManager.shared.currentUser.id)
                .child(Folder.trainingVideo)
                .child(fileName)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        reference.putData(data, metadata: metadata) { (_, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            reference.downloadURL { (url, error) in
                
                if let error = error {
                    completion(.failure(error))
                }
                
                if let url = url {
                    completion(.success(url))
                }
            }
        }
    }
    
    func removeScreenShot(fileName: String) {
        
        self.storageReference
            .child(AuthManager.shared.currentUser.id)
            .child(Folder.trainingVideo)
            .child(fileName)
            .delete { error in
                
                if let error = error {
                    print(error)
                }
        }
    }
    
    func uploadVideo(fileName: String,
                     url: URL,
                     completion: @escaping (Result<URL, Error>) -> Void) {
        
        let reference =
            self.storageReference
                .child(AuthManager.shared.currentUser.id)
                .child(Folder.trainingVideo)
                .child(fileName)
        
        let metadata = StorageMetadata()
        metadata.contentType = "video/mp4"
        
        reference.putFile(from: url, metadata: metadata) { (_, error) in
                
            if let error = error {
                completion(.failure(error))
                return
            }
            
            reference.downloadURL(completion: { (url, error) in
                
                if let error = error {
                    completion(.failure(error))
                }
                
                if let url = url {
                    completion(.success(url))
                }
            })
        }
    }
    
    private struct Folder {
        
        static let trainingVideo = "training_video"
    }
}
