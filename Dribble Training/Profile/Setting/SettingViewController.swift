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
    
    private let settings: [[Setting]] = [[.privacyPolicy], [.logOut]]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        settingView.delegate = self
        
        settingView.tableView.registerCellWithNib(id: SettingTableViewCell.id)
    }
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settings[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.id, for: indexPath)
        
        guard let settingCell = cell as? SettingTableViewCell else { return cell }
        
        let setting = settings[indexPath.section][indexPath.row]
        
        settingCell.titleLabel.text = setting.rawValue
        
        switch setting {
            
        case .logOut:
            
            settingCell.titleLabel.textColor = .red
            
            settingCell.accessoryType = .none
            
        default: break
        }
        
        return settingCell
    }
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let setting = settings[indexPath.section][indexPath.row]
        
        switch setting {
            
        case .privacyPolicy:
            
            show(PrivacyViewController(), sender: nil)
            
        case .logOut:
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            guard let mainPage = appDelegate.window?.rootViewController as? MainViewController else { return }
            
            KeychainManager.shared.uid = nil
            
            AuthManager.shared.currentUser = nil
            
            mainPage.dismiss(animated: true, completion: mainPage.checkUID)
        }
    }
}
