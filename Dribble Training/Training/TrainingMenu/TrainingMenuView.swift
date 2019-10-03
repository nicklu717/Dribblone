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
    
    func prepareTraining(forModeIndex indexPath: IndexPath)
}

class TrainingMenuView: UIView {
    
    // MARK: - Property Declaration
    
    weak var delegate: TrainingMenuViewDelegate?
    
    @IBOutlet var tableView: UITableView! {
        
        didSet {
            tableView.registerCellWithNib(id: TrainingMenuTableViewCell.id)
            
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
        
        delegate?.prepareTraining(forModeIndex: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            
            cell.alpha = 1
        }
    }
}
