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
    
    private var openCellsIndexPaths = [IndexPath]()
    
    @IBAction func buttonAction(_ sender: Any) {
        beginGame()
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
            var indexPath = IndexPath(row: Int.random(in: 0...2), section: Int.random(in: 0...2))
            
            while self.openCellsIndexPaths.contains(indexPath) {
                indexPath = IndexPath(row: Int.random(in: 0...2), section: Int.random(in: 0...2))
            }
            
            let cell = self.collectionView.cellForItem(at: indexPath) as? SquareCollectionViewCell
            self.openCellsIndexPaths.append(indexPath)
            
            cell?.activateCell()
            
            print("At \(self.timeCount), \(indexPath)")
            self.timeCount = self.timeCount - 1
            if self.timeCount == 0 {
                self.timer?.invalidate()
                self.timeCount = 15
                print("Final score \(self.score)")
            }
        })
    }
}

extension SquaresViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SquareCollectionViewCell {
            cell.cellMadePoint()
            if let index = openCellsIndexPaths.firstIndex(of: indexPath) {
                openCellsIndexPaths.remove(at: index)
            }
        }
    }
}

extension SquaresViewController: SquareCellDelegate {
    func cellMadePoint(cell: UICollectionViewCell) {
        let _cell = cell as! SquareCollectionViewCell
        _cell.cellExpired()
        score = score + 1
    }
    
    func cellExpired(cell: UICollectionViewCell) {
        let indexPath = collectionView.indexPath(for: cell)
        if let index = openCellsIndexPaths.firstIndex(of: indexPath!) {
            openCellsIndexPaths.remove(at: index)
        }
    }
}
