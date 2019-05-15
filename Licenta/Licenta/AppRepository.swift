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
        guard let name = userNickname else { return "" }
        return name
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
    
    func toLevelsView() {
        router.toLevelsView(nickname: getNickname())
    }
    
    func finishedTimerGame(for difficulty: Int) {
        let game = Game()
        game.id = GamesIds.Timer.getId()
        game.name = GamesIds.Timer.rawValue
        
        userFinishedGame(gameId: game.id, difficulty: difficulty)
    }
    
    func userFinishedGame(gameId: Int, difficulty: Int) {
        if realm.objects(User.self).count > 0 {
            let user = realm.objects(User.self).first
            
            if (user?.lastDifficultyCompletedGames.count)! < 3 {
                if user?.lastDifficultyCompletedGames.contains(gameId) == false {
                    try! realm.write {
                        user?.lastDifficultyCompletedGames.append(gameId)
                    }
                }
            }
        }
        startRandomGame(difficulty: difficulty)
    }
    
    func startRandomGame(difficulty: Int) {
        if realm.objects(User.self).count > 0 {
            let user = realm.objects(User.self).first
            
            if (user?.lastDifficultyCompletedGames.count)! < 3 {
                let finishedGames = Array(user!.lastDifficultyCompletedGames)
                var nextGameId = 0
                
                while finishedGames.contains(nextGameId) {
                    nextGameId = Int.random(in: 1...numberOfGames)
                }
                
                switch nextGameId {
                case 1: router.toBullsEyeGame(nickname: user!.nickname, difficulty: difficulty)
                case 2: router.toTimerGame(nickname: user!.nickname, difficulty: difficulty)
                case 3: break
                default: break
                }
            }
        }
    }
}

enum GamesIds: String {
    case BullsEye = "BullsEye"
    case Timer = "Timer"
    
    func getId() -> Int {
        switch self {
        case .BullsEye:
            return 1
        case .Timer:
            return 2
        }
    }
}
