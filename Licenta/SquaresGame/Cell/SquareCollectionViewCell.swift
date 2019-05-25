//
//  SquareCollectionViewCell.swift
//  Licenta
//
//  Created by Paul on 16/05/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import UIKit

protocol SquareCellDelegate: class {
    func cellMadePoint()
}

class SquareCollectionViewCell: UICollectionViewCell {
    private var timer: Timer?
    private var timeCount: Int = 0
    private var difficulty: Int = 0
    
    var isCellActivated: Bool = false
    private var delegate: SquareCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(difficulty: Int, delegate: SquareCellDelegate) {
        self.difficulty = difficulty
        self.timeCount = 1000 / difficulty
        self.delegate = delegate
    }
    
    func activateCell() {
        self.isCellActivated = true
        backgroundColor = .green
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {
            _ in
            while self.timeCount > 0 {
                self.timeCount = self.timeCount - 1
            }
            
            if self.timeCount == 0 {
                self.cellExpired()
            }
        })
    }
    
    func cellMadePoint() {
        if isCellActivated {
            print("POINT!")
            backgroundColor = .black
            timer?.invalidate()
            delegate?.cellMadePoint()
        }
    }
    
    func cellExpired() {
        isCellActivated = false
        backgroundColor = .black
        timeCount = 100 / difficulty
        timer?.invalidate()
    }
}
