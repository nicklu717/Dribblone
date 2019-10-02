//
//  WaterfallLayout.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/10/1.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class WaterfallLayout: UICollectionViewLayout {
    
    let numberOfColumn: Int = 2
    let cellPadding: CGFloat = 3
    
    var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    var contentHeight: CGFloat = 0
    var contentWidth: CGFloat {
        
        guard let collectionView = collectionView else { return 0 }
        
        let inset = collectionView.contentInset
        
        return collectionView.bounds.width - (inset.left + inset.right)
    }
    
    override var collectionViewContentSize: CGSize {
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        
        guard let collectionView = collectionView else { return }
        
        layoutAttributes = []
        
        var xOffsets = [CGFloat]()
        
        let columnWidth = contentWidth / CGFloat(numberOfColumn)
        
        for column in 0..<numberOfColumn {
            
            xOffsets.append(columnWidth * CGFloat(column))
        }
        
        var yOffsets = [CGFloat](repeating: 0, count: numberOfColumn)
        
        for section in 0..<collectionView.numberOfSections {
        
            for index in 0..<collectionView.numberOfItems(inSection: section) {
                
                // Calculate Item Frame
                
                let itemHeight = CGFloat.random(in: 200...300)
                
                let column = index % numberOfColumn
                
                let itemFrame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: itemHeight)
                
                let insetFrame = itemFrame.insetBy(dx: cellPadding, dy: cellPadding)
                
                // Add Attribute
                
                let indexPath = IndexPath(item: index, section: section)
                
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                attribute.frame = insetFrame
                
                layoutAttributes.append(attribute)
                
                // Update Offset
                
                yOffsets[column] += itemHeight
                
                // Update Content Height
                
                contentHeight = max(contentHeight, itemFrame.maxY)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return layoutAttributes
    }
}
