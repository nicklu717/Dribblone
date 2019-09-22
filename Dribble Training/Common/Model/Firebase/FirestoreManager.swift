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
    
    private let firestore = Firestore.firestore()
    
    func fetchMemberData(forUID uid: String,
                         completion: @escaping (Result<Member, Error>) -> Void) {
        
        firestore
            .collection(Collection.member)
            .document(uid)
            .getDocument { (documentSnapshot, error) in
                
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = documentSnapshot?.data() {
                    
                    guard let member: Member = self.getObject(from: data)
                        else {
                            print("Member Data Converting Failure")
                            return
                    }
                    
                    completion(.success(member))
                }
        }
    }
    
    func fetchTrainingResult(for member: Member?,
                             completion: @escaping (Result<[TrainingResult], Error>) -> Void) {
        
        guard let member = member
            else {
                
                firestore
                    .collection(Collection.member)
                    .order(by: "date", descending: true)
                    .getDocuments { (querySnapshot, error) in
                        
                        self.trainingResultHandler(querySnapshot: querySnapshot,
                                                   error: error,
                                                   completion: completion)
                }
                
                return
        }
        
        firestore
            .collection(Collection.trainingResults)
            .whereField("id", isEqualTo: member.id)
            .order(by: "date", descending: true)
            .getDocuments { (querySnapshot, error) in
                
                self.trainingResultHandler(querySnapshot: querySnapshot,
                                           error: error,
                                           completion: completion)
        }
    }
    
//    func checkAvailable(forID id: String, completion: @escaping (Bool) -> Void) {
//
//        firestore
//            .collection(Collection.member)
//            .whereField("id", isEqualTo: id)
//            .getDocuments { (querySnapshot, error) in
//
//                if let querySnapshot = querySnapshot, querySnapshot.documents.isEmpty {
//
//                    completion(false)
//
//                } else {
//
//                    completion(true)
//                }
//        }
//    }
    
    func update(member: Member, completion: (() -> Void)?) {
        
        guard
            let dictionary = getDictionary(from: member)
            else {
                print("Member Data Encoding Failure")
                return
        }
        
        firestore
            .collection(Collection.member)
            .document(member.uid)
            .setData(dictionary) { error in
            
                if let error = error {
                    print(error)
                }
                
                completion?()
        }
    }
    
    func upload(trainingResult: TrainingResult,
                for member: Member,
                completion: (() -> Void)? = nil) {
        
        guard
            let dictionary = getDictionary(from: trainingResult)
            else {
                print("Training Result Data Encoding Failure")
                return
        }
        
        let reference =
            firestore
                .collection(Collection.trainingResults)
                .addDocument(data: dictionary)
        
        firestore
            .collection(Collection.member)
            .document(member.uid)
            .updateData(
                [Collection.trainingResults: FieldValue.arrayUnion([reference.documentID])]
        )
        
        completion?()
    }
    
    private func getObject<T: Decodable>(from dictionary: [String: Any]) -> T? {
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary,
                                                  options: [])
            
            let object = try JSONDecoder().decode(T.self, from: data)
            
            return object
            
        } catch {
            
            print(error)
            
            return nil
        }
    }
    
    private func getDictionary<T: Encodable>(from object: T) -> [String: Any]? {
        
        do {
            
            let data = try JSONEncoder().encode(object)
            
            let dictionary = try JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
            ) as? [String: Any]
            
            return dictionary
            
        } catch {
            
            print(error)
            
            return nil
        }
    }
    
    private func trainingResultHandler(
        querySnapshot: QuerySnapshot?,
        error: Error?,
        completion: @escaping (Result<[TrainingResult], Error>) -> Void) {
        
        guard
            let querySnapshot = querySnapshot
            else {
                if let error = error {
                    completion(.failure(error))
                }
                return
        }
        
        var trainingResults: [TrainingResult] = []
        
        for document in querySnapshot.documents {
            
            guard
                let trainingResult: TrainingResult = self.getObject(from: document.data())
                
                else {
                    print("Invalid Training Result")
                    continue
            }
            
            trainingResults.append(trainingResult)
        }
        
        completion(.success(trainingResults))
    }
    
    private struct Collection {
        
        static let member = "member"
        
        static let trainingResults = "training_results"
    }
}
