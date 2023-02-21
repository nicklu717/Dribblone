//
//  FirestoreManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/12.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import FirebaseFirestore

class FirestoreManager {
    
    static let `default` = FirestoreManager(firestore: .firestore())
    
    private let firestore: Firestore
    
    init(firestore: Firestore) {
        self.firestore = firestore
    }
    
    func fetchMemberData(forUID uid: UID,
                         completion: @escaping (Result<Member?, Error>) -> Void) {
        let reference = firestore.collection(.member).document(uid)
        reference.getDocument { (documentSnapshot, error) in
            if let error = error {
                completion(.failure(error))
            }
            if let data = documentSnapshot?.data() {
                let member: Member? = self.getObject(from: data)
                
                completion(.success(member))
            } else {
                completion(.success(nil))
            }
        }
    }
    
    func fetchMemberData(forID id: ID,
                         completion: @escaping (Result<Member?, Error>) -> Void) {
        let reference = firestore.collection(.member).whereField(MemberKey.id.rawValue, isEqualTo: id)
        reference.getDocuments { (documentSnapshot, error) in
            if let error = error {
                completion(.failure(error))
            }
            if let data = documentSnapshot?.documents.first?.data() {
                guard let member: Member = self.getObject(from: data) else { return }
                completion(.success(member))
            } else {
                completion(.success(nil))
            }
        }
    }
    
    func fetchTrainingResult(for member: Member? = nil,
                             completion: @escaping (Result<[TrainingResult], Error>) -> Void) {
        var reference: Query = firestore.collection(.trainingResults)
        if let member = member {
            reference = reference.whereField(TrainingResultsKey.id.rawValue, isEqualTo: member.id)
        }
        reference = reference.order(by: TrainingResultsKey.date.rawValue, descending: true)
        reference.getDocuments { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            
            var trainingResults: [TrainingResult] = []
            
            for document in querySnapshot.documents {
                guard let trainingResult: TrainingResult = self.getObject(from: document.data()) else { continue }
                trainingResults.append(trainingResult)
            }
            completion(.success(trainingResults))
        }
    }
    
    func checkAvailable(for id: ID, completion: @escaping (Bool) -> Void) {
        let reference = firestore.collection(.member).whereField(MemberKey.id.rawValue, isEqualTo: id)
        reference.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error)
            }
            if let documents = querySnapshot?.documents {
                completion(documents.isEmpty)
            }
        }
    }
    
    func block(member: Member) {
        guard let currentUser = AuthManager.default.currentUser else { return }
        let currentUserReference = firestore.collection(.member).document(currentUser.uid)
        currentUserReference.updateMemberData([
            .blockList: .arrayUnion([member.id]),
            .followings: .arrayRemove([member.id]),
            .followers: .arrayRemove([member.id])
        ])
        let memberReference = firestore.collection(.member).document(member.uid)
        memberReference.updateMemberData([
            .blockList: .arrayUnion([currentUser.id]),
            .followers: .arrayRemove([currentUser.id]),
            .followings: .arrayRemove([currentUser.id])
        ])
    }
    
    func follow(member: Member) {
        guard let currentUser = AuthManager.default.currentUser else { return }
        let currentUserReference = firestore.collection(.member).document(currentUser.uid)
        currentUserReference.updateMemberData([
            .followings: .arrayUnion([member.id])
        ])
        let memberReference = firestore.collection(.member).document(member.uid)
        memberReference.updateMemberData([
            .followers: .arrayUnion([currentUser.id])
        ])
    }
    
    func unfollow(member: Member) {
        guard let currentUser = AuthManager.default.currentUser else { return }
        let currentUserReference = firestore.collection(.member).document(currentUser.uid)
        currentUserReference.updateMemberData([
            .followings: .arrayRemove([member.id])
        ])
        let memberReference = firestore.collection(.member).document(member.uid)
        memberReference.updateMemberData([
            .followers: .arrayRemove([currentUser.id])
        ])
    }
    
    func createMember(uid: UID, id: ID, completion: (() -> Void)?) {
        let member = Member(uid: uid,
                            id: id,
                            displayName: .empty,
                            followers: [],
                            followings: [],
                            blockList: [],
                            trainingResults: [],
                            picture: .empty,
                            teams: [],
                            teamInvitations: [],
                            blockTeamList: [])
        guard let dictionary = getDictionary(from: member) else { return }
        let reference = firestore.collection(.member).document(member.uid)
        reference.setData(dictionary) { (error) in
            if let error = error {
                print(error)
            }
            completion?()
        }
    }
    
    func upload(trainingResult: TrainingResult,
                for member: Member,
                completion: (() -> Void)? = nil) {
        guard let dictionary = getDictionary(from: trainingResult) else { return }
        let resultReference = firestore.collection(.trainingResults).addDocument(data: dictionary)
        let memberReference = firestore.collection(.member).document(member.uid)
        memberReference.updateMemberData([
            .trainingResults: .arrayUnion([resultReference.documentID])
        ])
        
        completion?()
    }
    
    // MARK: - Private Method
    private func getObject<Object: Decodable>(from dictionary: [String: Any]) -> Object? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let object = try JSONDecoder().decode(Object.self, from: data)
            return object
        } catch {
            print(error)
            return nil
        }
    }
    
    private func getDictionary<Object: Encodable>(from object: Object) -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(object)
            let rawDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard let dictionary = rawDictionary as? [String: Any] else { return nil }
            return dictionary
        } catch {
            print(error)
            return nil
        }
    }
}

private extension FirestoreManager {
    
    enum CollectionKey: String {
        case member = "member"
        case trainingResults = "training_results"
    }
    
    enum MemberKey: String {
        case uid = "uid"
        case id = "id"
        case displayName = "display_name"
        case followers = "followers"
        case followings = "followings"
        case blockList = "block_list"
        case trainingResults = "training_results"
        case picture = "picture"
    }
    
    enum TrainingResultsKey: String {
        case id = "id"
        case date = "date"
        case mode = "mode"
        case points = "points"
        case videoURL = "video_url"
    }
}

private extension Firestore {
    
    func collection(_ collectionKey: FirestoreManager.CollectionKey) -> CollectionReference {
        return collection(collectionKey.rawValue)
    }
}

private extension DocumentReference {
    
    func updateMemberData(_ fields: [FirestoreManager.MemberKey: FieldValue], completion: ((Error?) -> Void)? = nil) {
        var processedFields: [AnyHashable: Any] = [:]
        fields.forEach { memberKey, fieldValue in
            processedFields[memberKey.rawValue] = fieldValue
        }
        updateData(processedFields, completion: completion)
    }
}
