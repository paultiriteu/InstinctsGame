//
//  TapViewController.swift
//  Licenta
//
//  Created by Paul on 23/04/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    @IBOutlet weak var finishedGameView: FinishedGameView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var nextRoundButton: UIButton!
    @IBOutlet weak var roundsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private let repository: AppRepository
    
    private var timer: Timer?
    private var timerCount: Int = 0
    private var actualTime: Int = 0
    private var target: Int = 0
    private var range: Int = 0
    private var difficulty: Int
    private var score: Int = 0
    private var round: Int = 0
    private var hasTimerStarted: Bool = false

    @IBAction func backButtonAction(_ sender: Any) {
        timer?.invalidate()
        repository.popViewController()
    }
    
    @IBAction func nextRoundButtonAction(_ sender: Any) {
        hasTimerStarted = false
        beginGame()
        round = round + 1
        nextRoundButton.isHidden = true
        mainView.isUserInteractionEnabled = true
    }
    
    init(repository: AppRepository, difficulty: Int) {
        self.repository = repository
        self.difficulty = difficulty
        super.init(nibName: "TimerViewController", bundle: Bundle(for: TimerViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        let alert = UIAlertController(title: "Welcome to the timer game!", message: "You have to reach 100 points to pass this mini-game. Good luck!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Alright, let's go!", style: .default, handler: { _ in
            self.beginGame()
        }))
        self.present(alert, animated: true, completion: nil)
//        beginGame()
    }
    
    func configureUI() {
        finishedGameView.configure(gameName: "Timer Game", difficulty: self.difficulty, delegate: self)
        finishedGameView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
        mainView.addGestureRecognizer(tap)

        mainView.layer.cornerRadius = mainView.frame.size.height / 2
        
        mainView.isHidden = true
        mainLabel.isHidden = true
        titleLabel.isHidden = true
        
        mainLabel.textColor = UIColor.white
        
        self.round = 1
        scoreLabel.text = "Score: \(score)"
        roundsLabel.text = "Rounds left: 5"
        
        nextRoundButton.layer.cornerRadius = 10
        nextRoundButton.setTitle("Next round", for: .normal)
        nextRoundButton.isHidden = true
    }
    
    @objc func viewWasTapped() {
        if hasTimerStarted == false {
            configureTimerForWarmup()
        } else {
            timer?.invalidate()
            mainView.isUserInteractionEnabled = false
            getConclusion()
        }
    }

    func configureTimerForWarmup() {
        self.mainView.isUserInteractionEnabled = false
        timerCount = 3
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self]
            _ in
            guard let welf = self else {return}
            
            if welf.timerCount != 0 {
                welf.titleLabel.text = String(Int(welf.timerCount))
            } else {
                welf.titleLabel.text = "GO!!!"
                welf.timer?.invalidate()
                welf.configureTimerForGame()
            }
            welf.timerCount = welf.timerCount - 1
        })
    }
    
    func configureTimerForGame() {
        self.mainView.isUserInteractionEnabled = true
        self.mainView.backgroundColor = UIColor(red: 196/255, green: 47/255, blue: 47/255, alpha: 1)
        self.hasTimerStarted = true
        
        self.mainLabel.text = String(self.actualTime / 10) + "." + String(self.actualTime % 10)
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self]
            _ in
            guard let welf = self else {return}
            welf.actualTime = welf.actualTime - 1
            
            if welf.actualTime == 0 {
                welf.timer?.invalidate()
                welf.titleLabel.text = "You missed it!"
            }
            welf.mainLabel.text = String(welf.actualTime / 10) + "." + String(welf.actualTime % 10)
        })
    }
    
    func getRandomTime() -> Int {
        let totalTime = Int.random(in: 3...5)
        
        return totalTime * 10
    }
    
    func getTarget() -> Int {
        let targetTime = Int.random(in: 1...Int(actualTime/2))
        
        return targetTime
    }
    
    func getRange() -> Int {
        let rangeTime: Int
        switch difficulty {
            case 1:
                rangeTime = Int.random(in:  3...5)
            case 2:
                rangeTime = Int.random(in: 2...3)
            case 3:
                rangeTime = Int.random(in: 1...2)
        default: return 0
        }
        return rangeTime
    }
    
    func beginGame() {
        mainView.isHidden = false
        mainLabel.isHidden = false
        titleLabel.isHidden = false
        
        titleLabel.text = "Press START when you are ready"
        mainLabel.text = "START"
        mainView.backgroundColor = UIColor(red: 47/255, green: 196, blue: 47/255, alpha: 1)
        
        self.actualTime = getRandomTime()
        self.range = getRange()
        self.target = getTarget()
        
        let alert = UIAlertController(title: "This is the Timer Game!", message: "You have to stop the timer at \(self.target / 10).\(self.target % 10), but don't worry, you have a range of \(self.range / 10).\(self.range % 10) seconds!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Alright, let's go!", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getConclusion() {
        if actualTime == target {
            score = score + 500
            
            let alert = UIAlertController(title: "CONGRATULATIONS!!!", message: "You have hit the perfect time!\nYou got 500 points!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Thanks!", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            nextRoundButton.isHidden = false
            scoreLabel.text = "Score: \(score)"
            roundsLabel.text = "Rounds left: \(5 - round)"
            return
        }
        
        var result = 0
        
        if (target-range)...(target+range) ~= actualTime {
            if actualTime > target {
                result = 100 * ((target + range) - actualTime)
            } else {
                result = 100 * (actualTime - (target - range))
            }
            
            if result == 0 {
                self.score = self.score + 50
            } else {
                self.score = self.score + result
            }
            
            let alert = UIAlertController(title: "Nice!", message: "You stopped the timer 0.\(abs(target - actualTime)) seconds away from the target! You got \(result) points!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Thanks!", style: .default, handler: { _ in
                self.checkIfGameIsDone()
            }))
            self.present(alert, animated: true, completion: nil)
            
            nextRoundButton.isHidden = false
        } else {
            let alert = UIAlertController(title: "Oh no!", message: "You're out of range! You didn't get any point!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Oops!", style: .default, handler: { _ in
                self.checkIfGameIsDone()
            }))
            self.present(alert, animated: true, completion: nil)
            nextRoundButton.isHidden = false
        }
        
        scoreLabel.text = "Score: \(score)"
        roundsLabel.text = "Rounds left: \(5 - round)"
    }
    
    func checkIfGameIsDone() {
        if round == 5 {
            if score >= 1000 {
                repository.finishedTimerGame(for: difficulty, with: score)
                finishedGameView.isHidden = false
            } else {
                let alert = UIAlertController(title: "You lost!", message: "You couldn't complete this level", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "To main menu", style: .default, handler: { _ in
                    self.repository.toLevelsView()
                }))
                alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
                    self.score = 0
                    self.round = 1
                    self.roundsLabel.text = "Rounds left: 5"
                    self.scoreLabel.text = "Score: 0"
                    self.beginGame()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension TimerViewController: FinishedGameDelegate {
    func finishedGame() {
        repository.startRandomGame(difficulty: difficulty)
    }
}
