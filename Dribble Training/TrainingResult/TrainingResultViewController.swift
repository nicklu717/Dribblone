//
//  TrainingResultViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class TrainingResultViewController: UIViewController {
    
//    var trainingResults: [TrainingResult] = []
    
    @IBOutlet var trainingResultView: TrainingResultView! {
        didSet {
//            trainingResultView.delegate = self
        }
    }
    
    var trainingResult: TrainingResult?
}

//extension TrainingResultViewController: TrainingResultViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//}
