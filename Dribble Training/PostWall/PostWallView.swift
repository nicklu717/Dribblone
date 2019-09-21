//
//  PostWallView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/21.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class PostWallView: UIView {
    
    @IBOutlet var trainingResultPageView: UIView!
    
    var trainingResultPage: TrainingResultViewController!
    
    func showTrainingResults() {
        
        trainingResultPageView.addSubview(trainingResultPage.view)
        
        trainingResultPage.view.frame = trainingResultPageView.bounds
    }
}
