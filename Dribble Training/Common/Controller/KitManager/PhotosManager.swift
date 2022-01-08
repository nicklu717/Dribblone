//
//  PhotosManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/29.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Photos

class PhotosManager {
    
    static let `default` = PhotosManager(resourceManager: .default())
    
    private let resourceManager: PHAssetResourceManager
    
    init(resourceManager: PHAssetResourceManager) {
        self.resourceManager = resourceManager
    }
    
    func fetchResource(for mediaType: PHAssetMediaType) -> PHAssetResource? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: .creationDate, ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: mediaType, options: fetchOptions)
        
        guard
            let videoPHAsset = fetchResult.firstObject,
            let videoResource = PHAssetResource.assetResources(for: videoPHAsset).first
        else {
            return nil
        }
        
        return videoResource
    }
    
    func writeData(to url: URL, resource: PHAssetResource, completion: (() -> Void)?) {
        resourceManager.writeData(for: resource, toFile: url, options: nil) { (error) in
            if let error = error {
                print(error)
                return
            }
            completion?()
        }
    }
    
    private enum SortKey {
        static let creationDate = "creationDate"
    }
}

private extension NSSortDescriptor {
    
    enum SortKey: String {
        case creationDate
    }
    
    convenience init(key: SortKey, ascending: Bool, selector: Selector? = nil) {
        self.init(key: key.rawValue, ascending: ascending, selector: selector)
    }
}
