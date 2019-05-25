//
//  SquaresViewController.swift
//  Licenta
//
//  Created by Paul on 16/05/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import UIKit

class SquaresViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let repository: AppRepository
    private let difficulty: Int
    private var timer: Timer?
    private var timeCount: Int = 15
    private var score: Int = 0
    
    @IBAction func buttonAction(_ sender: Any) {
        
    }
    
    init(repository: AppRepository, difficulty: Int) {
        self.repository = repository
        self.difficulty = difficulty
        
        super.init(nibName: "SquaresViewController", bundle: Bundle(for: SquaresViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: Bundle(for: SquareCollectionViewCell.self)), forCellWithReuseIdentifier: "SquareCollectionViewCell")
        collectionView.isScrollEnabled = false
        
        let alert = UIAlertController(title: "Squares Game", message: "Welcome to Squares Game!\nYou have 15 seconds to hit as many squares as you can!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Thanks!", style: .default, handler: { _ in
            self.beginGame()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func beginGame() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
            _ in
            var row = Int.random(in: 0...2)
            var section = Int.random(in: 0...2)
            
            var cell = self.collectionView.cellForItem(at: IndexPath(row: row, section: section)) as? SquareCollectionViewCell
            
            while cell?.isCellActivated == true {
                row = Int.random(in: 0...2)
                section = Int.random(in: 0...2)
                cell = self.collectionView.cellForItem(at: IndexPath(row: row, section: section)) as? SquareCollectionViewCell
            }
            
            cell?.activateCell()
            
            print("At \(self.timeCount), cell row \(row+1), section \(section+1)")
            self.timeCount = self.timeCount - 1
            if self.timeCount == 0 {
                self.timer?.invalidate()
                print("Final score \(self.score)")
            }
        })
    }
}

extension SquaresViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCollectionViewCell", for: indexPath) as? SquareCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(difficulty: self.difficulty, delegate: self)
        cell.backgroundColor = .black
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SquareCollectionViewCell {
            cell.cellMadePoint()
        }
    }
}

extension SquaresViewController: SquareCellDelegate {
    func cellMadePoint() {
        score = score + 1
    }
}
