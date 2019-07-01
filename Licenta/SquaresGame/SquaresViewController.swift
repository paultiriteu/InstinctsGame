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
    @IBOutlet weak var targetScoreLabel: UILabel!
    @IBOutlet weak var finishedGameView: FinishedGameView!
    @IBOutlet weak var imageView: UIImageView!
    
    private let repository: AppRepository
    private let difficulty: Int
    private var cellsPerRow: Int
    private var timeCount: Int
    private var timer: Timer?
    private var score: Int = 0
    private var targetScore: Int = 0

    private var openCellsIndexPaths = [IndexPath]()
    
    @IBAction func backButtonAction(_ sender: Any) {
        timer?.invalidate()
        repository.popViewController()
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        beginGame()
    }
    
    init(repository: AppRepository, difficulty: Int) {
        self.repository = repository
        self.difficulty = difficulty
        self.timeCount = 15 * difficulty
        self.cellsPerRow = difficulty > 1 ? 6 : 3
        
        switch difficulty {
        case 1:
            targetScore = 12
        case 2:
            targetScore = 25
        case 3:
            targetScore = 35
        default:
            break
        }
        
        super.init(nibName: "SquaresViewController", bundle: Bundle(for: SquaresViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.isHidden = true
        finishedGameView.isHidden = true
        
        targetScoreLabel.text = "Target score\n\(targetScore) points"
        
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
        score = 0
        let totalCells = self.cellsPerRow * self.cellsPerRow
        let interval = 1.0 / Double(difficulty)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [weak self]
            _ in
            guard let welf = self else {return}
            var indexPath = IndexPath(row: Int.random(in: 0...totalCells - 1), section: 0)
            
            while welf.openCellsIndexPaths.contains(indexPath) {
                indexPath = IndexPath(row: Int.random(in: 0...totalCells - 1), section: 0)
            }
            
            let cell = welf.collectionView.cellForItem(at: indexPath) as? SquareCollectionViewCell
            welf.openCellsIndexPaths.append(indexPath)
            
            cell?.activateCell()
            
            print("At \(welf.timeCount), \(indexPath)")
            welf.timeCount = welf.timeCount - 1
            if welf.timeCount == 0 {
                welf.timer?.invalidate()
            }
        })
    }
    
    func getConclusion() {
        if score >= targetScore {
            repository.finishedSquaresGame(for: difficulty, with: score)
            finishedGameView.configure(gameName: "Squares Game", difficulty: self.difficulty, delegate: self)
            finishedGameView.isHidden = false
        } else {
            let alert = UIAlertController(title: "You lost!", message: "You couldn't complete this level", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "To main menu", style: .default, handler: { _ in
                self.repository.toLevelsView()
            }))
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
                self.score = 0
                self.titleLabel.isHidden = true
                self.beginGame()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension SquaresViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsPerRow * cellsPerRow
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCollectionViewCell", for: indexPath) as? SquareCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(difficulty: self.difficulty, delegate: self)
        cell.backgroundColor = .black
        
        return cell
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

extension SquaresViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 5
        let collectionViewSize = collectionView.bounds.size.width - padding * 2
        let cellWidth = (collectionViewSize / CGFloat(cellsPerRow))
        let height = cellWidth
        
        return CGSize(width: cellWidth, height: height)
    }
    
    private func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

extension SquaresViewController: SquareCellDelegate {
    func cellMadePoint(cell: UICollectionViewCell) {
        let _cell = cell as! SquareCollectionViewCell
        _cell.cellExpired()
        score = score + 1
        titleLabel.text = "\(score)"
        titleLabel.isHidden = false
    }
    
    func cellExpired(cell: UICollectionViewCell) {
        let indexPath = collectionView.indexPath(for: cell)
        if let index = openCellsIndexPaths.firstIndex(of: indexPath!) {
            openCellsIndexPaths.remove(at: index)
        }
        
        if timeCount == 0 && openCellsIndexPaths.count == 0 {
            getConclusion()
            timeCount = 15 * difficulty
        }
    }
}

extension SquaresViewController: FinishedGameDelegate {
    func finishedGame() {
        repository.startRandomGame(difficulty: difficulty)
    }
}
