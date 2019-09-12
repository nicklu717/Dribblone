//
//  FirestoreStruct.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/12.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

//import Foundation

struct Collection {
    
    static let member = "Member"
    
    static let trainingResults = "training_results"
}

struct Member: Codable {
    
    let id: String
    
    let email: String
    
    var followers: [String]
    
    var followings: [String]
    
    var trainingResults: [TrainingResult]
    
    var picture: String
    
    enum CodingKeys: String, CodingKey {
        
        case id, email, followers, followings, picture
        
        case trainingResults = "training_results"
    }
}

struct TrainingResult: Codable {
    
    let date: Double
    
    let mode: String
    
    let points: Int
    
    var videoLocalID: String!
    
    enum CodingKeys: String, CodingKey {
        
        case date, mode, points
        
        case videoLocalID = "video_local_id"
    }
}
