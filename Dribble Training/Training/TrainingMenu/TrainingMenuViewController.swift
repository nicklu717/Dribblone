//
//  TrainingMenuViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class TrainingMenuViewController: UIViewController {
    
    // MARK: - Property Declaration
    @IBOutlet var trainingMenuView: TrainingMenuView! {
        didSet { trainingMenuView.delegate = self }
    }
    
    private var instructionPage: InstructionViewController!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInstructionPage()
    }
    
    // MARK: - Private Method
    private func setupInstructionPage() {
        let viewController = UIStoryboard.instruction.instantiateInitialViewController()
        guard let instructionPage = viewController as? InstructionViewController else { return }
        instructionPage.loadViewIfNeeded()
        self.instructionPage = instructionPage
    }
}

extension TrainingMenuViewController: TrainingMenuViewDelegate {
    
    var trainingModes: [TrainingMode] {
        return [.crossover, .low, .rightHand, .leftHand, .mStyle, .random]
    }
    
    func trainingCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrainingMenuTableViewCell.id, for: indexPath)
        guard let modeCell = cell as? TrainingMenuTableViewCell else { return cell }
        let mode = trainingModes[indexPath.row]
        modeCell.modeNameLabel.text = mode.rawValue
        let urls = UIImage.Background.urls
        let index = indexPath.row % urls.count
        modeCell.backgroundImageView.setImage(withURLString: urls[index])
        return modeCell
    }
    
    func prepareTraining(forModeIndex indexPath: IndexPath) {
        let mode = trainingModes[indexPath.row]
        instructionPage.trainingMode = mode
        present(instructionPage, animated: true, completion: nil)
    }
}
