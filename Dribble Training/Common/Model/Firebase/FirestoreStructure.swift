//
//  DatabaseStructure.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/12.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Foundation

typealias UID = String
typealias ID = String

struct Member: Codable {
    
    let uid: UID
    
    let id: ID
    
    let displayName: String
    
    let followers: [ID]
    
    let followings: [ID]
    
    var blockList: [ID]
    
    let trainingResults: [String]
    
    let picture: String
    
    enum CodingKeys: String, CodingKey {
        
        case uid, id, followers, followings, picture
        
        case displayName = "display_name"
        
        case blockList = "block_list"
        
        case trainingResults = "training_results"
    }
}

struct TrainingResult: Codable {
    
    let id: ID
    
    let date: Double
    
    let mode: String
    
    let points: Int
    
    var videoURL: String!
    
    enum CodingKeys: String, CodingKey {
        
        case id, date, mode, points
        
        case videoURL = "video_url"
    }
}
