//
//  SettingsViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/24.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SettingsViewDelegate {
    
    // MARK: - Property Declaration
    
    @IBOutlet var settingsView: SettingsView!
    
    private let settings: [Setting] = [.logOut]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        settingsView.delegate = self
    }
    
    private enum Setting: String {
        
        case logOut = "Log Out"
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
