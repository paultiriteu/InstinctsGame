//
//  AppRepository.swift
//  Licenta
//
//  Created by Paul Tiriteu on 06/03/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import Foundation
import RealmSwift

class AppRepository {
    private var userNickname: String?
    private let router: MainAppRouter
    private var realm: Realm
    
    let numberOfGames = 3
    
    init(router: MainAppRouter) {
        self.router = router
        realm = try! Realm()
    }
    
    func getNickname() -> String {
        guard let user = realm.objects(User.self).first else { return "" }
        return user.nickname
    }
    
    func setNickname(nickname: String) {
        self.userNickname = nickname
        
        let user = User()
        user.nickname = nickname
        user.difficultiesCompleted.append(0)
        user.lastDifficultyCompletedGames.append(0)
        
        try! realm.write {
            realm.add(user)
        }
    }
    
    func toBullsEyeGame(difficulty: Int) {
        router.toBullsEyeGame(nickname: getNickname(), difficulty: difficulty)
    }
    
    func toTimerGame(difficulty: Int) {
        router.toTimerGame(nickname: getNickname(), difficulty: difficulty)
    }
    
    func toSquaresGame(difficulty: Int) {
        router.toSquaresGame(nickname: getNickname(), difficulty: difficulty)
    }
    
    func toLevelsView() {
        router.toLevelsView(nickname: getNickname())
    }
    
    func finishedTimerGame(for difficulty: Int, with score: Int) {
        let game = Game()
        game.id = GamesIds.Timer.getId()
        game.name = GamesIds.Timer.rawValue
        
        userFinishedGame(gameId: game.id, difficulty: difficulty, with: score)
    }
    
    func finishedBullsEyeGame(for difficulty: Int, with score: Int) {
        let game = Game()
        game.id = GamesIds.BullsEye.getId()
        game.name = GamesIds.BullsEye.rawValue
        
        userFinishedGame(gameId: game.id, difficulty: difficulty, with: score)
    }
    
    func finishedSquaresGame(for difficulty: Int, with score: Int) {
        let game = Game()
        game.id = GamesIds.Squares.getId()
        game.name = GamesIds.Squares.rawValue
        
        userFinishedGame(gameId: game.id, difficulty: difficulty, with: score)
    }
    
    func userFinishedGame(gameId: Int, difficulty: Int, with score: Int) {
        if realm.objects(User.self).count > 0 {
            let user = realm.objects(User.self).first
            let totalScore = user!.totalScore + score
            
            if (user?.lastDifficultyCompletedGames.count)! < 3 {
                if user?.lastDifficultyCompletedGames.contains(gameId) == false {
                    try! realm.write {
                        user?.lastDifficultyCompletedGames.append(gameId)
                        user?.totalScore = totalScore
                    }
                }
            }
            else {
                let difficultiesCompleted = user?.difficultiesCompleted
                try! realm.write {
                    user?.difficultiesCompleted.append(difficultiesCompleted!.last! + 1)
                    let list = List<Int>()
                    list.append(0)
                    user?.lastDifficultyCompletedGames = list
                    user?.totalScore = totalScore
                }
            }
        }
    }
    
    func startRandomGame(difficulty: Int) {
        if realm.objects(User.self).count > 0 {
            let user = realm.objects(User.self).first
            
            if user!.lastDifficultyCompletedGames.count == 0 {
                router.toLevelsView(nickname: getNickname())
            }
            if (user?.lastDifficultyCompletedGames.count)! < 4 {
                let finishedGames = Array(user!.lastDifficultyCompletedGames)
                var nextGameId = 0
                
                while finishedGames.contains(nextGameId) {
                    nextGameId = Int.random(in: 1...numberOfGames)
                }
                
                switch nextGameId {
                case 1: toBullsEyeGame(difficulty: difficulty)
                case 2: toTimerGame(difficulty: difficulty)
                case 3: toSquaresGame(difficulty: difficulty)
                default: break
                }
            } else {
                router.toLevelsView(nickname: getNickname())
            }
        }
    }
    
    func getScore() -> Int {
        if realm.objects(User.self).count > 0 {
            let user = realm.objects(User.self).first
            
            return user!.totalScore
        }
        
        return 0
    }
    
    func getDifficulties() -> [Int] {
        if realm.objects(User.self).count > 0 {
            let user = realm.objects(User.self).first
            return Array(user!.difficultiesCompleted)
        }
        return [Int]()
    }
}

enum GamesIds: String {
    case BullsEye = "BullsEye"
    case Timer = "Timer"
    case Squares = "Squares"
    
    func getId() -> Int {
        switch self {
        case .BullsEye:
            return 1
        case .Timer:
            return 2
        case .Squares:
            return 3
        }
    }
}
