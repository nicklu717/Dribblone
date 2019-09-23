//
//  DatabaseStructure.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/12.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Foundation

struct Member: Codable {
    
    let uid: String
    
    let id: String
    
    let displayName: String
    
    let followers: [String]
    
    let followings: [String]
    
    let trainingResults: [String]
    
    let picture: String
    
    enum CodingKeys: String, CodingKey {
        
        case uid, id, followers, followings, picture
        
        case displayName = "display_name"
        
        case trainingResults = "training_results"
    }
}

struct TrainingResult: Codable {
    
    let id: String
    
    let date: Double
    
    let mode: String
    
    let points: Int
    
    var videoURL: String!
    
    enum CodingKeys: String, CodingKey {
        
        case id, date, mode, points
        
        case videoURL = "video_url"
    }
}
