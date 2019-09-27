//
//  PrivacyViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/27.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {
    
    // MARK: - Property
    
    let privacyView = PrivacyView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let urlString = "https://www.privacypolicies.com/privacy/view/b92ac1d815d87bff3541fba4b45890be"
        
        guard let url = URL(string: urlString)
            else {
                print("Invalid Privacy Policy URL")
                return
        }
        
        privacyView.frame = view.bounds
        
        view.addSubview(privacyView)
        
        privacyView.setupWebView(url: url)
    }
}
