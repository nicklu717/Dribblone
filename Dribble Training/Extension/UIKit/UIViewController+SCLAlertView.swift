//
//  SCLAlertView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/23.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import SCLAlertView

extension UIViewController {
    
    func showConfirmAlert(title: String,
                          subTitle: String = .empty,
                          confirmHandler: @escaping () -> Void) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false,
                                                    hideWhenBackgroundViewIsTapped: true)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("BLOCK", action: confirmHandler)
        alertView.addButton("Cancel", action: {})
        alertView.showError(title, subTitle: subTitle)
    }
}
