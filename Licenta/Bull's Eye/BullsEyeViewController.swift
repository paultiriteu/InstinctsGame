//
//  BullsEyeViewController.swift
//  Licenta
//
//  Created by Paul Tiriteu on 06/03/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import UIKit

class BullsEyeViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetScoreLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var targetTextLabel: UILabel!
    @IBOutlet weak var finishedGameView: FinishedGameView!
    @IBOutlet weak var hitMeButton: UIButton!
    
    private var currentValue = 0
    private var targetValue = 0
    private var score = 0
    private var roundsLeft = 0
    private var level = 0
    private let repository: AppRepository
    
    @IBAction func backButtonAction(_ sender: Any) {
        repository.popViewController()
    }
    
    init(repository: AppRepository, difficulty: Int) {
        self.level = difficulty
        self.repository = repository
        super.init(nibName: "BullsEyeViewController", bundle: Bundle(for: BullsEyeViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.minimumTrackTintColor = UIColor.orange
        slider.maximumTrackTintColor = UIColor.gray
        
        hitMeButton.layer.backgroundColor = UIColor.orange.cgColor
        hitMeButton.setTitleColor(UIColor.white, for: .normal)
        hitMeButton.layer.cornerRadius = 10
        hitMeButton.setTitle("HIT ME!", for: .normal)
        
        self.finishedGameView.isHidden = true
        let roundedValue = slider.value.rounded()
        currentValue = Int(roundedValue)
        self.startNewGame()
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        print("\(slider.value)")
        let roundedValue = slider.value.rounded()
        currentValue = Int(roundedValue)
    }
    
    @IBAction func hitMeAction(_ sender: Any) {
        let difference = abs(targetValue - currentValue)
        var points = 100 - difference
        
        let title: String
        if difference == 0 {
            title = "Perfect!"
            points += 100
        } else if difference < 5 {
            title = "You almost had it!"
            if difference == 1 {
                points += 50
            }
        } else if difference < 10 {
            title = "Pretty good!"
        } else {
            title = "Not even close!"
        }
        
        score += points
        
        let message = "\nYou scored \(points) points"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {
            action in
            self.startNewRound()
        })
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
//    
//    @IBAction func startOverAction(_ sender: Any) {
//        startNewGame()
//    }
    
    func startNewGame() {
        score = 0
        roundsLeft = 10
        startNewRound()
    }
    
    func updateLevel() {
        switch level {
        case 1:
            if score >= 1000 {
                levelPassedAlert()
                updateLabels()
                break
            } else {
                lostAlert()
            }
        case 2:
            if score >= 1300 {
                levelPassedAlert()
                updateLabels()
                break
            } else {
                lostAlert()
            }
        case 3:
            if score >= 1600 {
                levelPassedAlert()
                updateLabels()
                break
            } else {
                lostAlert()
            }
            
        default: break
        }
    }
    
    func startNewRound() {
        targetValue = Int.random(in: 1...100)
        currentValue = 50
        slider.value = Float(currentValue)
        
        if roundsLeft == 0 {
            updateLevel()
            score = 0
            roundsLeft = 10
        }
        
        updateLabels()
        roundsLeft -= 1
    }
    
    func updateLabels() {
        var target: Int = 0
        
        switch level {
        case 1:
            target = 1000
            break
        case 2:
            target = 1300
            break
        case 3:
            target = 1600
            break
        default:
            break
        }
        
        targetLabel.text = String(format: "Move the slider as close as you can to %d points!", targetValue)
        scoreLabel.text = String(format: "Score: %d", score)
        roundLabel.text = String(format: "Rouds left: %d", roundsLeft)
        targetScoreLabel.text = "Target score: \(target)"
    }
    
    func showWinnerAlert() {
        let message = "YOU WON THE BULL'S EYE GAME!"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {
            action in
            self.level = 1
            self.score = 0
            self.roundsLeft = 10
            self.startNewRound()
        })
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func lostAlert() {
        let message = "You didn't get enough points..."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "To main menu", style: .default, handler: { _ in
            self.repository.toLevelsView()
        }))
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: {
            action in
            self.level = 1
            self.score = 0
            self.roundsLeft = 10
            self.startNewRound()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func levelPassedAlert() {
//        let message = "You passed level \(level-1)!"
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let action = UIAlertAction(title: "Awesome!", style: .default)
//
//        alert.addAction(action)
//
//        present(alert, animated: true, completion: nil)
        finishedGameView.isHidden = false
        finishedGameView.configure(gameName: "Bull's Eye", difficulty: self.level, delegate: self)
        repository.finishedBullsEyeGame(for: self.level, with: score)
    }
}

extension BullsEyeViewController: FinishedGameDelegate {
    func finishedGame() {
        repository.startRandomGame(difficulty: level)
    }
}
