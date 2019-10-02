//
//  PostWallView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/21.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol PostWallViewDelegate: AnyObject {
    
    func numberOfItemsInSection(_ section: Int) -> Int
    
    func cellForItemAt(_ indexPath: IndexPath,
                       for collectionView: UICollectionView) -> UICollectionViewCell
}

class PostWallView: UIView {
    
    // MARK: - Property
    
    weak var delegate: PostWallViewDelegate?
    
    @IBOutlet var collectionView: UICollectionView! {
        
        didSet {
            
            let inset: CGFloat = 3
            
            collectionView.contentInset = UIEdgeInsets(top: inset, left: inset,
                                                       bottom: inset, right: inset)
            
            collectionView.registerCellWithNib(id: PostWallCollectionViewCell.id)
            
            collectionView.dataSource = self
        }
    }
    
    // MARK: - Instance Method
    
    func reloadCollectionView() {
        
        collectionView.reloadData()
    }
}

extension PostWallView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return delegate?.numberOfItemsInSection(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return delegate?.cellForItemAt(indexPath, for: collectionView) ?? UICollectionViewCell()
    }
}
