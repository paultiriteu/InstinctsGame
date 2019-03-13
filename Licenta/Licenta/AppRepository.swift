//
//  AppRepository.swift
//  Licenta
//
//  Created by Paul Tiriteu on 06/03/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import Foundation

class AppRepository {
    private var userNickname: String
    private let router: MainAppRouter
    
    init(nickname: String, router: MainAppRouter) {
        self.router = router
        self.userNickname = nickname
    }
    
    func getNickname() -> String {
        return userNickname
    }
    
    func setNickname(nickname: String) {
        self.userNickname = nickname
    }
    
    func toBullsEyeGame() {
        router.toBullsEyeGame(nickname: userNickname)
    }
}
