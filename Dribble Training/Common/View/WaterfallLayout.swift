//
//  WaterfallLayout.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/10/1.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class WaterfallLayout: UICollectionViewLayout {
    
    var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    var contentHeight: CGFloat = 0
    var contentWidth: CGFloat {
        
        guard let collectionView = collectionView else { return 0 }
        
        let inset = collectionView.contentInset
        
        return collectionView.bounds.width - (inset.left + inset.right)
    }
    
    override var collectionViewContentSize: CGSize {
        
        return CGSize(width: contentHeight, height: contentWidth)
    }
    
    override func prepare() {
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return layoutAttributes
    }
}
