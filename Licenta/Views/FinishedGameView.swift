//
//  FinishedGameView.swift
//  Licenta
//
//  Created by Paul on 11/05/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import UIKit

protocol FinishedGameDelegate: class {
    func finishedGame()
}

class FinishedGameView: CustomView {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    private weak var delegate: FinishedGameDelegate?
    private var gameName: String = ""
    private var difficulty: String = ""
    
    @IBAction func buttonAction(_ sender: Any) {
        delegate?.finishedGame()
    }
    
    override func configureUI() {
        button.layer.cornerRadius = 10
    }
    
    func configure(gameName: String, difficulty: Int, delegate: FinishedGameDelegate) {
        self.delegate = delegate
        self.gameName = gameName
        
        switch difficulty {
            case 1: self.difficulty = "easy"
            case 2: self.difficulty = "medium"
            case 3: self.difficulty = "hard"
            default: break
        }
        
        label.text = "Congratulations!\nYou won the \(self.difficulty) level of the \(gameName)!"
        button.setTitle("To the next challange", for: .normal)
    }
    
}
