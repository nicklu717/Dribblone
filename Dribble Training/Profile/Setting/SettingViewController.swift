//
//  SettingViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/24.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, SettingViewDelegate {
    
    // MARK: - Property Declaration
    
    @IBOutlet var settingView: SettingView!
    
    private let settings: [Setting] = [.logOut]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        settingView.delegate = self
        
        settingView.tableView.registerCellWithNib(id: SettingTableViewCell.id)
    }
}

extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.id,
                                                       for: indexPath) as? SettingTableViewCell
            else {
                print("Settings Table View Cell Not Exist")
                return UITableViewCell()
        }
        
        let setting = settings[indexPath.row]
        
        cell.titleLabel.text = setting.rawValue
        
        switch setting {
            
        case .logOut:
            
            cell.titleLabel.textColor = .red
            
            cell.accessoryType = .none
        }
        
        return cell
    }
}
