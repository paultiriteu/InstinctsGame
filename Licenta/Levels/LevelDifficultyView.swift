//
//  LevelDifficultyView.swift
//  Licenta
//
//  Created by Paul Tiriteu on 13/03/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import Foundation
import UIKit

class LevelDifficultyView: CustomView {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var lockedView: UIView!
    @IBOutlet weak var lockedLabel: UILabel!
    
    func configure(backgroundColor: UIColor, textColor: UIColor, text: String) {
        self.backgroundColor = backgroundColor
        self.textLabel.text = text
        self.textLabel.textColor = textColor
    }
    
    override func configureUI() {
        lockedView.backgroundColor = UIColor.darkGray
        lockedLabel.text = "LOCKED"
        lockedLabel.textColor = UIColor.white
    }
}
