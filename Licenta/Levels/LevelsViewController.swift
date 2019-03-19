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
        easyDifficultyView.configure(backgroundColor: UIColor.green, textColor: UIColor.white, text: "EASY")
        mediumDifficultyView.configure(backgroundColor: UIColor.orange, textColor: UIColor.white, text: "MEDIUM")
        hardDifficultyView.configure(backgroundColor: UIColor.red, textColor: UIColor.black, text: "HARD")
        
        easyDifficultyView.layer.cornerRadius = 10
        mediumDifficultyView.layer.cornerRadius = 10
        hardDifficultyView.layer.cornerRadius = 10
    }
    
}
