//
//  TapViewController.swift
//  Licenta
//
//  Created by Paul on 23/04/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import UIKit

class TapViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var helperButton: UIButton!
    
    private var isTimerRunning: Bool = false
    private var timer: Timer?
    private var timerCount: Int = 0
    private var limitTime: Int = 0
    private var target: Int = 0
    private var range: Int = 0
    private var difficulty: Int
    
    @IBAction func helperButtonAction(_ sender: Any) {
        timer?.invalidate()
        getConclusion()
    }
    
    init(difficulty: Int) {
        self.difficulty = difficulty
        super.init(nibName: "TapViewController", bundle: Bundle(for: TapViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
        mainView.addGestureRecognizer(tap)

        mainLabel.text = "START"
        helperButton.setTitle("STOP", for: .normal)
        mainView.layer.cornerRadius = mainView.frame.size.height / 2
        
        beginGame()
    }
    
    @objc func viewWasTapped() {
        configureTimerForWarmup()
    }

    func configureTimerForWarmup() {
        self.mainView.isUserInteractionEnabled = false
        timerCount = 3
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
            _ in
            if self.timerCount != 0 {
                self.titleLabel.text = String(Int(self.timerCount))
            } else {
                self.titleLabel.text = "GO!!!"
                self.timer?.invalidate()
                self.configureTimerForGame()
            }
            self.timerCount = self.timerCount - 1
        })
    }
    
    func configureTimerForGame() {
        self.mainLabel.text = String(self.limitTime / 10) + "." + String(self.limitTime % 10)
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {
            _ in
            self.limitTime = self.limitTime - 1
            
            if self.limitTime == 0 {
                self.timer?.invalidate()
                self.titleLabel.text = "You missed it!"
            }
            self.mainLabel.text = String(self.limitTime / 10) + "." + String(self.limitTime % 10)
        })
    }
    
    func getRandomTime() -> Int {
        let totalTime = Int.random(in: 3...5)
        
        return totalTime * 10
    }
    
    func getTarget() -> Int {
        let targetTime = Int.random(in: 1...Int(limitTime/2))
        
        return targetTime
    }
    
    func getRange() -> Int {
        let rangeTime: Int
        switch difficulty {
            case 1:
                rangeTime = Int.random(in:  5...7)
            case 2:
                rangeTime = Int.random(in: 3...5)
            case 3:
                rangeTime = Int.random(in: 1...3)
        default: return 0
        }
        return rangeTime
    }
    
    func beginGame() {
        self.limitTime = getRandomTime()
        self.range = getRange()
        self.target = getTarget()
        
        let alert = UIAlertController(title: "This is the Timer Game!", message: "You have to stop the timer at \(self.target / 10).\(self.target % 10), but don't worry, you have a range of \(self.range * 10) miliseconds!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Alright, let's go!", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getConclusion() {
        if (target-range)...(target+range) ~= limitTime {
            print("YOU MADE IT!")
        } else {
            print("BAD TIMING")
        }
    }
}
