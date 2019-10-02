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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTrainingManagerPage()
    }
    
    // MARK: - Private Method
    
    private func setupTrainingManagerPage() {
        
        let storyboard = UIStoryboard.training
        
        let viewController = storyboard.instantiateInitialViewController()
        
        trainingPage = viewController as? TrainingViewController
        
        trainingPage.loadViewIfNeeded()
    }
}

extension TrainingMenuViewController: TrainingMenuViewDelegate {
    
    var trainingModes: [TrainingMode] {
        
        return [.crossover, .low, .rightHand, .leftHand, .mStyle, .random]
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
        
        let urls = UIImage.Background.urls
        
        let index = indexPath.row % urls.count
        
        modeCell.backgroundImageView.setImage(withURLString: urls[index])
        
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
            
//            strongSelf.trainingResultPage.trainingResults = [trainingResult]
//
//            strongSelf.show(strongSelf.trainingResultPage, sender: nil)
        }
        
        present(trainingPage, animated: true, completion: nil)
    }
}
