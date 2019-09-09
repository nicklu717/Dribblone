//
//  UIStoryboard+Extension.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static var trainingLobby: UIStoryboard { return storyboard("TrainingLobby")}
    
    static var training: UIStoryboard { return storyboard("Training")}
    
    static var trainingResult: UIStoryboard { return storyboard("TrainingResult")}
    
    private static func storyboard(_ name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
}
