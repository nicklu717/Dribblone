//
//  DatabaseManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/12.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let firestore = Firestore.firestore()
    
    private struct Collection {
        
        static let member = "member"
        
        static let trainingResult = "training_result"
    }
    
    func fetchMemberData(forUID uid: String,
                         completion: @escaping (Result<Member, Error>) -> Void) {
        
        firestore
            .collection(Collection.member)
            .document(uid)
            .getDocument { (documentSnapshot, error) in
                
                guard
                    let data = documentSnapshot?.data(),
                    let member: Member = self.getObject(from: data)
                    else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                }
                
                completion(.success(member))
        }
    }
    
    func fetchTrainingResult(for member: Member,
                             completion: @escaping (Result<[TrainingResult], Error>) -> Void) {
        
        firestore
            .collection(Collection.trainingResult)
            .whereField("id", isEqualTo: member.id)
            .order(by: "date", descending: true)
            .getDocuments { (querySnapshot, error) in
                
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
    
    func upload(member: Member, uid: String) {
        
        guard
            let dictionary = getDictionary(from: member)
            else {
                print("Member Data Encoding Failure")
                return
        }
        
        firestore
            .collection(Collection.member)
            .document(uid)
            .setData(dictionary) { error in
            
                if let error = error {
                    print(error)
                }
        }
    }
    
//    func upload(trainingResult: TrainingResult, completion: ((TrainingResult) -> Void)?) {
//
//        guard let dictionary = getDictionary(from: trainingResult)
//
//            else {
//                print("Invalid Training Result Dictionary")
//                return
//        }
//
//        firestore
//            .collection(Collection.member)
//            .document("nicklu717")
//            .collection(Collection.trainingResults)
//            .addDocument(data: dictionary) { (error) in
//
//                if let error = error {
//                    print(error)
//                    return
//                }
//
//                self.fetchTrainingResult()
//        }
//
//        completion?(trainingResult)
//    }
    
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
}
