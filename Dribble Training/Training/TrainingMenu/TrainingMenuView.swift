//
//  TrainingMenuView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol TrainingMenuViewDelegate: AnyObject {
    
    var trainingModes: [TrainingMode] { get }
    
    func trainingCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    
    func startTraining(forModeIndexPath indexPath: IndexPath)
}

class TrainingMenuView: UIView {
    
    weak var delegate: TrainingMenuViewDelegate?
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
}

extension TrainingMenuView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return delegate?.trainingModes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return delegate?.trainingCell(for: tableView, at: indexPath) ?? UITableViewCell()
    }
}

extension TrainingMenuView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.startTraining(forModeIndexPath: indexPath)
    }
}
