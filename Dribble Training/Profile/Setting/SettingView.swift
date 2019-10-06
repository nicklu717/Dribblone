//
//  SettingView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/24.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol SettingViewDelegate: UITableViewDataSource, UITableViewDelegate {}

class SettingView: UIView {
    
    weak var delegate: SettingViewDelegate? {
        
        didSet {
        
            tableView.dataSource = delegate
            
            tableView.delegate = delegate
        }
    }
    
    @IBOutlet var tableView: UITableView!
}
