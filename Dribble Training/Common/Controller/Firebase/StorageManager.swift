//
//  StorageManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/17.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import FirebaseStorage

class StorageManager {
    
    static let `default` = StorageManager(storage: .storage())
    
    private let storageReference: StorageReference
    
    init(storage: Storage) {
        self.storageReference = storage.reference()
    }
    
    func getProfilePicture(forID id: ID, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storageReference.child(id).child("profile.jpeg")
        reference.downloadURL { (url, error) in
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
        guard let currentUser = AuthManager.default.currentUser else { return }
        guard let data = image.jpegData(compressionQuality: 0.3) else { return }
        let reference = storageReference.trainingVideoReference(forUserID: currentUser.id, fileName: fileName)
        let metadata = StorageMetadata()
        metadata.set(contentType: .jpeg)
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
        guard let currentUser = AuthManager.default.currentUser else { return }
        let reference = storageReference.trainingVideoReference(forUserID: currentUser.id, fileName: fileName)
        reference.delete { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func uploadVideo(fileName: String,
                     url: URL,
                     completion: @escaping (Result<URL, Error>) -> Void) {
        guard let currentUser = AuthManager.default.currentUser else { return }
        let reference = storageReference.trainingVideoReference(forUserID: currentUser.id, fileName: fileName)
        let metadata = StorageMetadata()
        metadata.set(contentType: .mp4)
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
}

private extension StorageReference {
    
    func trainingVideoReference(forUserID userID: ID, fileName: String) -> StorageReference {
        return child(userID).child("training_video").child(fileName)
    }
}

private extension StorageMetadata {
    
    enum ContentType: String {
        case jpeg = "image/jpeg"
        case mp4 = "video/mp4"
    }

    func set(contentType: ContentType) {
        self.contentType = contentType.rawValue
    }
}
