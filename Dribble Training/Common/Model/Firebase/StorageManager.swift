//
//  StorageManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/12.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import FirebaseFirestore

class StorageManager {
    
    static let shared = StorageManager()
    
    var trainingResults: [TrainingResult] = []
    
    let firestore = Firestore.firestore()
    
    private struct Collection {
        
        static let member = "member"
        
        static let trainingResults = "training_results"
    }
    
    func upload(trainingResult: TrainingResult, completion: ((TrainingResult) -> Void)?) {
        
        guard let data = trainingResult.dictionary()
            
            else {
                print("Invalid Training Result Dictionary")
                return
        }
        
        firestore
            .collection(Collection.member)
            .document("nicklu717")
            .collection(Collection.trainingResults)
            .addDocument(data: data)
        
        completion?(trainingResult)
    }
    
    
}
