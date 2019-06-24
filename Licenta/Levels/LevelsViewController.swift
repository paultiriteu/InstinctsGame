//
//  LevelsViewController.swift
//  Licenta
//
//  Created by Paul Tiriteu on 13/03/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import UIKit

class LevelsViewController: UIViewController {
    @IBOutlet weak var easyDifficultyView: LevelDifficultyView!
    @IBOutlet weak var mediumDifficultyView: LevelDifficultyView!
    @IBOutlet weak var hardDifficultyView: LevelDifficultyView!
    @IBOutlet weak var scoreLabel: UILabel!

    private let repository: AppRepository
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get { return UIInterfaceOrientationMask.landscapeRight }
    }
    
    init(repository: AppRepository) {
        self.repository = repository
        super.init(nibName: "LevelsViewController", bundle: Bundle(for: LevelsViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        self.view.backgroundColor = UIColor.gray
        
        scoreLabel.text = "\(repository.getScore())"
        
        easyDifficultyView.configure(backgroundColor: UIColor.gray, textColor: UIColor.white, text: "EASY")
        mediumDifficultyView.configure(backgroundColor: UIColor.darkGray, textColor: UIColor.white, text: "MEDIUM")
        hardDifficultyView.configure(backgroundColor: UIColor.black, textColor: UIColor.darkGray, text: "HARD")
        
        easyDifficultyView.layer.shadowColor = UIColor.black.cgColor
        easyDifficultyView.layer.shadowOpacity = 1
        easyDifficultyView.layer.shadowOffset = CGSize.zero
        easyDifficultyView.layer.shadowRadius = 10
        
        mediumDifficultyView.layer.shadowColor = UIColor.black.cgColor
        mediumDifficultyView.layer.shadowOpacity = 1
        mediumDifficultyView.layer.shadowOffset = CGSize.zero
        mediumDifficultyView.layer.shadowRadius = 10
        
        hardDifficultyView.layer.shadowColor = UIColor.black.cgColor
        hardDifficultyView.layer.shadowOpacity = 1
        hardDifficultyView.layer.shadowOffset = CGSize.zero
        hardDifficultyView.layer.shadowRadius = 10
        
        easyDifficultyView.layer.cornerRadius = 10
        mediumDifficultyView.layer.cornerRadius = 10
        hardDifficultyView.layer.cornerRadius = 10
        
        easyDifficultyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOnEasy)))
        mediumDifficultyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOnMedium)))
        hardDifficultyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOnHard)))
        
        easyDifficultyView.openView()
        let openViews = repository.getDifficulties()
        
        if openViews.count == 3 {
            
        } else {
            for view in openViews {
                switch view {
                case 2: mediumDifficultyView.openView()
                    mediumDifficultyView.isUserInteractionEnabled = true
                case 3: hardDifficultyView.openView()
                    hardDifficultyView.isUserInteractionEnabled = true
                default: break
                }
            }
        }
    }
    
    @objc func tappedOnEasy() {
        repository.startRandomGame(difficulty: 1)
    }
    
    @objc func tappedOnMedium() {
        repository.startRandomGame(difficulty: 2)
    }
    
    @objc func tappedOnHard() {
        repository.startRandomGame(difficulty: 3)
    }
}
