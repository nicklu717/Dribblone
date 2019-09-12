//
//  FirestoreManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/12.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import FirebaseFirestore

class FirestoreManager {
    
    static let shared = FirestoreManager()
    
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
            .addDocument(data: data) { (error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                self.fetchTrainingResult()
        }
        
        completion?(trainingResult)
    }
    
    func fetchTrainingResult() {
        
        firestore
            .collection(Collection.member)
            .document("nicklu717")
            .collection(Collection.trainingResults)
            .order(by: "date", descending: true)
            .getDocuments { (querySnapshot, error) in
                
                guard
                    let querySnapshot = querySnapshot
                    else {
                        print(error!)
                        return
                }
                
                self.trainingResults = []
                
                for document in querySnapshot.documents {
                    
                    guard let trainingResult = self.getTrainingResult(from: document.data())
                        
                        else {
                            print("Invalid Training Result")
                            return
                    }
                    
                    self.trainingResults.append(trainingResult)
                }
        }
    }
    
    private func getTrainingResult(from dictionary: [String: Any]) -> TrainingResult? {
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary,
                                                  options: [])
            
            let trainingResult = try JSONDecoder().decode(TrainingResult.self, from: data)
            
            return trainingResult
            
        } catch {
            
            print(error)
            
            return nil
        }
    }
}
