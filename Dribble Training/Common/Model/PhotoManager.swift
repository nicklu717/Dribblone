//
//  PhotoKit.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/29.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Photos

class PhotoManager {
    
    static let shared = PhotoManager()
    
    private let resourceManager = PHAssetResourceManager.default()
    
    func fetchResource(for mediaType: PHAssetMediaType) -> PHAssetResource? {
        
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: SortKey.creationDate,
                                                         ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: mediaType, options: fetchOptions)
        
        guard
            let videoPHAsset = fetchResult.firstObject,
            let videoResource = PHAssetResource.assetResources(for: videoPHAsset).first
        else {
            print("Video Fetching Failure")
            return nil
        }
        
        return videoResource
    }
    
    func writeData(to url: URL, resource: PHAssetResource, completion: (() -> Void)?) {
        
        resourceManager.writeData(for: resource, toFile: url, options: nil) { error in
                
            if let error = error {
                print(error)
                return
            }
            
            completion?()
        }
    }
    
    private struct SortKey {
        
        static let creationDate = "creationDate"
    }
}
