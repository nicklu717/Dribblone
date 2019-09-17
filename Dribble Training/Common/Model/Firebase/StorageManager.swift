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
    
    func upload(videoID: String, videoData: Data) {
        
        guard
            let member = MemberManager.shared.currentUser
            else {
                print("Member Not Exist")
                return
        }
        
        let videoReference =
            storageReference
                .child(member.id)
                .child(Folder.trainingVideo)
                .child("1111.mp4")
        
        videoReference.putData(
            videoData,
            metadata: nil) { (_, error) in
            
                if let error = error {
                    print(error)
                    return
                }
                
                videoReference.downloadURL { (url, error) in
                    
                    if let url = url {
                        print("Download URL: \(url)")
                    } else {
                        print(error!)
                    }
                }
        }
    }
    
    private struct Folder {
        
        static let trainingVideo = "training_video"
    }
}
