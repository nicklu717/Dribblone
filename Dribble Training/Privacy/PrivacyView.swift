//
//  PrivacyView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/27.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import WebKit

class PrivacyView: UIView {
    
    // MARK: - Property
    
    let webView = WKWebView()
    
    // MARK: - Instance Method
    
    func setupWebView(url: URL) {
        
        let request = URLRequest(url: url)
        
        webView.load(request)
        
        webView.frame = bounds
        
        addSubview(webView)
    }
}
