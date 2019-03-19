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
        
        try! realm.write {
            realm.add(user)
        }
    }
    
    func toBullsEyeGame() {
        router.toBullsEyeGame(nickname: getNickname())
    }
    
    func toLevelsView() {
        router.toLevelsView(nickname: getNickname())
    }
}
