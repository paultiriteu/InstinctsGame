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
//        self.view.backgroundColor = UIColor.gray
        
        scoreLabel.text = "Total score: \(repository.getScore())"
        scoreLabel.textColor = UIColor.white
        
        easyDifficultyView.configure(backgroundColor: UIColor(red: 165/255, green: 244/255, blue: 140/255, alpha: 1), textColor: UIColor.black, text: "EASY")
        mediumDifficultyView.configure(backgroundColor: UIColor(red: 251/255, green: 255/255, blue: 58/255, alpha: 1), textColor: UIColor.black, text: "MEDIUM")
        hardDifficultyView.configure(backgroundColor: UIColor(red: 255/255, green: 110/255, blue: 58/255, alpha: 1), textColor: UIColor.black, text: "HARD")
        
        easyDifficultyView.layer.shadowColor = UIColor.black.cgColor
        easyDifficultyView.layer.shadowOpacity = 0.7
        easyDifficultyView.layer.shadowOffset = CGSize(width: 5, height: 5)
        easyDifficultyView.layer.shadowRadius = 10
        
        mediumDifficultyView.layer.shadowColor = UIColor.black.cgColor
        mediumDifficultyView.layer.shadowOpacity = 0.7
        mediumDifficultyView.layer.shadowOffset = CGSize(width: 5, height: 5)
        mediumDifficultyView.layer.shadowRadius = 10
        
        hardDifficultyView.layer.shadowColor = UIColor.black.cgColor
        hardDifficultyView.layer.shadowOpacity = 0.7
        hardDifficultyView.layer.shadowOffset = CGSize(width: 5, height: 5)
        hardDifficultyView.layer.shadowRadius = 10
        
        easyDifficultyView.layer.cornerRadius = 10
        mediumDifficultyView.layer.cornerRadius = 10
        hardDifficultyView.layer.cornerRadius = 10
        
        easyDifficultyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOnEasy)))
        mediumDifficultyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOnMedium)))
        hardDifficultyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOnHard)))
        
        easyDifficultyView.openView()
        let openViews = repository.getDifficulties()
        
        if openViews.count == 4 {
            
        } else {
            for view in openViews {
                switch view {
                case 1: mediumDifficultyView.openView()
                    mediumDifficultyView.isUserInteractionEnabled = true
                case 2: hardDifficultyView.openView()
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
