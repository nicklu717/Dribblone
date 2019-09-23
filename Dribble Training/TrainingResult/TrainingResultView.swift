//
//  TrainingResultView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol TrainingResultViewDelegate: UITableViewDataSource {
    
    func refreshTrainingResult()
}

class TrainingResultView: UIView {
    
    weak var delegate: TrainingResultViewDelegate? {
        didSet {
            setupTableView()
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    func endHeaderRefresh() {
        tableView.endHeaderRefresh()
    }
    
    // MARK: - Private Method
    
    private func setupTableView() {
        
        tableView.register(UINib(nibName: "TrainingResultTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "TrainingResultTableViewCell")
        
        tableView.dataSource = self.delegate
        
        tableView.addRefreshHeader { [weak self] in
            
            self?.delegate?.refreshTrainingResult()
        }
    }
}
