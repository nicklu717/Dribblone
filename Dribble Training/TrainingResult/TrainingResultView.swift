//
//  TrainingResultView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol TrainingResultViewDelegate: UITableViewDataSource {
    
    var trainingResults: [TrainingResult] { get }
}

class TrainingResultView: UIView {
    
    weak var delegate: TrainingResultViewDelegate?
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self.delegate
        }
    }
}
