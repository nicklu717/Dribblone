//
//  PhotoManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/13.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Photos

class PhotoManager {
    
    static let shared = PhotoManager()
    
    private let imageManager = PHImageManager.default()
    
    func requestPlayerItem(withLocalID id: String,
                           completion: @escaping (AVPlayerItem) -> Void) {
        
        let fetchRequest = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        
        guard
            let asset = fetchRequest.firstObject
            else {
                print("Asset Fetching Failure")
                return
        }
        
        imageManager.requestPlayerItem(
            forVideo: asset,
            options: nil) { (playerItem, _) in
                
                guard
                    let playerItem = playerItem
                    else {
                        print("Player Item Not Exist")
                        return
                }
                
                completion(playerItem)
        }
    }
    
    func avPlayer(playerItem: AVPlayerItem) -> AVPlayer {
        return AVPlayer(playerItem: playerItem)
    }
}
