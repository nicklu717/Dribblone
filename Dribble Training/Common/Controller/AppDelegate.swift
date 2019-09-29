//
//  AppDelegate.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/8/30.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import FirebaseCore
import Fabric
import Crashlytics
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()
        
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = true
        
        IQKeyboardManager.shared.enable = true
        
        return true
    }
}
