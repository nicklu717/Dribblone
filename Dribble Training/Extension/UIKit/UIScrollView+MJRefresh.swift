//
//  MJRefresh.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/23.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import MJRefresh

extension UIScrollView {
    
    func addRefreshHeader(refreshingBlock: @escaping () -> Void) {
        mj_header = MJRefreshNormalHeader(refreshingBlock: refreshingBlock)
    }
    
    func endHeaderRefresh() {
        mj_header.endRefreshing()
    }
}
