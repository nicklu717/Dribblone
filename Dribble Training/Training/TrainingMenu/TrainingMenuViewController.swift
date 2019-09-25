//
//  TrainingMenuViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class TrainingMenuViewController: UIViewController {
    
    // MARK: - Property Declartion
    
    @IBOutlet var trainingMenuView: TrainingMenuView! {
        didSet {
            trainingMenuView.delegate = self
        }
    }
    
    private var trainingPage: TrainingViewController!
    
    private var trainingResultPage: TrainingResultViewController!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTrainingManagerPage()
        
        setupTrainingResultPage()
    }
    
    // MARK: - Private Method
    
    private func setupTrainingManagerPage() {
        
        let storyboard = UIStoryboard.training
        
        let viewController = storyboard.instantiateInitialViewController()
        
        trainingPage = viewController as? TrainingViewController
        
        trainingPage.loadViewIfNeeded()
    }
    
    private func setupTrainingResultPage() {
        
        let storyboard = UIStoryboard.trainingResult
        
        let viewController = storyboard.instantiateInitialViewController()
        
        trainingResultPage = viewController as? TrainingResultViewController
        
        trainingResultPage.navigationItem.title = "Result"
        
        trainingResultPage.loadViewIfNeeded()
    }
}

extension TrainingMenuViewController: TrainingMenuViewDelegate{
    
    var trainingModes: [TrainingMode] {
        
        return [.crossover, .low, .random,
                .crossover, .low, .random,
                .crossover, .low, .random,
                .crossover, .low, .random]
    }
    
    func trainingCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        
        guard let modeCell = tableView.dequeueReusableCell(withIdentifier: TrainingMenuTableViewCell.id,
                                                           for: indexPath) as? TrainingMenuTableViewCell
            else {
                print("Training Menu Table View Cell Not Exist")
                return UITableViewCell()
        }
        
        let mode = trainingModes[indexPath.row]
        
        modeCell.modeNameLabel.text = mode.rawValue
        
        var k: String = ""
        
        switch indexPath.row % 5 {
            
        case 0: k = UIImage.Background.a1
        case 1: k = UIImage.Background.a2
        case 2: k = UIImage.Background.a3
        case 3: k = UIImage.Background.a4
        case 4: k = UIImage.Background.a5
            
        default: break
        }
        modeCell.backgroundImageView.setImage(withURLString: k, placeholder: nil)
        
        return modeCell
    }
    
    func startTraining(forModeIndexPath indexPath: IndexPath) {
        
        let mode = trainingModes[indexPath.row]
        
        trainingPage.setTrainingMode(to: mode)
        
        trainingPage.trainingCompletion = { [weak self] trainingResult in
            
            guard let strongSelf = self
                else {
                    print("Training Menu Not Exist")
                    return
            }
            
            strongSelf.trainingResultPage.trainingResults = [trainingResult]
            
            strongSelf.show(strongSelf.trainingResultPage, sender: nil)
        }
        
        present(trainingPage, animated: true, completion: nil)
    }
}
