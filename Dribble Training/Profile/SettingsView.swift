//
//  SettingsView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/24.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol SettingsViewDelegate: UITableViewDataSource {}

class SettingsView: UIView {
    
    weak var delegate: SettingsViewDelegate? {
        didSet {
            tableView.dataSource = delegate
        }
    }
    
    @IBOutlet var tableView: UITableView!
}
