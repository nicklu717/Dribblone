//
//  DatabaseStructure.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/12.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Foundation

// swiftlint:disable type_name
typealias UID = String
typealias ID = String
// swiftlint:enable type_name

struct Member: Codable {
    
    let uid: UID
    
    let id: ID
    
    let displayName: String
    
    let followers: [ID]
    
    var followings: [ID]
    
    var blockList: [ID]
    
    let trainingResults: [String]
    
    let picture: String
    
    let teams: [String]
    
    let teamInvitations: [String]
    
    let blockTeamList: [String]
    
    enum CodingKeys: String, CodingKey {
        
        case uid, id, followers, followings, picture, teams
        
        case displayName = "display_name"
        case blockList = "block_list"
        case trainingResults = "training_results"
        case teamInvitations = "team_invitations"
        case blockTeamList = "block_team_list"
    }
}

struct TrainingResult: Codable {
    
    let id: ID
    
    var date: Double
    
    var mode: String
    
    var points: Int
    
    var videoURL: String
    
    var screenShot: String
    
    enum CodingKeys: String, CodingKey {
        
        case id, date, mode, points
        
        case videoURL = "video_url"
        case screenShot = "screen_shot"
    }
}
