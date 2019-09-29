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
    
    private var currentUser: Member {
        
        return AuthManager.shared.currentUser
    }
    
    private var currentUserReference: DocumentReference {
        
        return firestore.collection(CollectionKey.member).document(currentUser.uid)
    }
    
    func fetchMemberData(forUID uid: UID,
                         completion: @escaping (Result<Member?, Error>) -> Void) {
        
        firestore
            .collection(CollectionKey.member)
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
                    
                } else {
                    
                    completion(.success(nil))
                }
        }
    }
    
    func fetchMemberData(forID id: ID,
                         completion: @escaping (Result<Member?, Error>) -> Void) {
        
        firestore
            .collection(CollectionKey.member)
            .whereField(MemberKey.id, isEqualTo: id)
            .getDocuments { (documentSnapshot, error) in
                
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = documentSnapshot?.documents.first?.data() {
                    
                    guard let member: Member = self.getObject(from: data)
                        else {
                            print("Member Data Converting Failure")
                            return
                    }
                    
                    completion(.success(member))
                    
                } else {
                    
                    completion(.success(nil))
                }
        }
    }
    
    func fetchTrainingResult(for member: Member? = nil,
                             completion: @escaping (Result<[TrainingResult], Error>) -> Void) {
        
        var reference: Query = firestore.collection(CollectionKey.trainingResults)
        
        if let member = member {
            reference = reference.whereField("id", isEqualTo: member.id)
        }
        
        reference
            .order(by: "date", descending: true)
            .getDocuments { (querySnapshot, error) in
                
                guard let querySnapshot = querySnapshot
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
    
    func checkAvailable(for id: ID, completion: @escaping (Bool) -> Void) {
        
        firestore
            .collection(CollectionKey.member)
            .whereField(MemberKey.id, isEqualTo: id)
            .getDocuments { (querySnapshot, error) in
                
                if let error = error {
                    print(error)
                }

                if let documents = querySnapshot?.documents {
                    completion(documents.isEmpty)
                }
        }
    }
    
    func block(member: Member) {
        
        currentUserReference.updateData([MemberKey.blockList: FieldValue.arrayUnion([member.id])])
        
        currentUserReference.updateData([MemberKey.followings: FieldValue.arrayRemove([member.id])])
        
        currentUserReference.updateData([MemberKey.followers: FieldValue.arrayRemove([member.id])])
        
        let memberReference = firestore.collection(CollectionKey.member).document(member.uid)
        
        memberReference.updateData([MemberKey.blockList: FieldValue.arrayUnion([currentUser.id])])
        
        memberReference.updateData([MemberKey.followers: FieldValue.arrayRemove([currentUser.id])])
        
        memberReference.updateData([MemberKey.followings: FieldValue.arrayRemove([currentUser.id])])
    }
    
    func follow(member: Member) {
        
        currentUserReference.updateData([MemberKey.followings: FieldValue.arrayUnion([member.id])])
        
        let memberReference = firestore.collection(CollectionKey.member).document(member.uid)
        
        memberReference.updateData([MemberKey.followers: FieldValue.arrayUnion([currentUser.id])])
    }
    
    func unfollow(member: Member) {
        
        currentUserReference.updateData([MemberKey.followings: FieldValue.arrayRemove([member.id])])
        
        let memberReference = firestore.collection(CollectionKey.member).document(member.uid)
        
        memberReference.updateData([MemberKey.followers: FieldValue.arrayRemove([currentUser.id])])
    }
    
    func create(member: Member, completion: (() -> Void)?) {
        
        guard let dictionary = getDictionary(from: member)
            else {
                print("Member Data Encoding Failure")
                return
        }
        
        firestore
            .collection(CollectionKey.member)
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
        
        guard let dictionary = getDictionary(from: trainingResult)
            else {
                print("Training Result Data Encoding Failure")
                return
        }
        
        let reference =
            firestore
                .collection(CollectionKey.trainingResults)
                .addDocument(data: dictionary)
        
        firestore
            .collection(CollectionKey.member)
            .document(member.uid)
            .updateData(
                [CollectionKey.trainingResults: FieldValue.arrayUnion([reference.documentID])]
        )
        
        completion?()
    }
    
    // MARK: - Private Method
    
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
    
    private struct CollectionKey {
        
        static let member = "member"
        
        static let trainingResults = "training_results"
    }
    
    private struct MemberKey {
        
        static let uid = "uid"
        static let id = "id"
        static let displayName = "display_name"
        static let followers = "followers"
        static let followings = "followings"
        static let blockList = "block_list"
        static let trainingResults = "training_results"
        static let picture = "picture"
    }
    
    private struct TrainingResultsKey {
        
        static let id = "id"
        static let date = "date"
        static let mode = "mode"
        static let points = "points"
        static let videoURL = "video_url"
    }
}
