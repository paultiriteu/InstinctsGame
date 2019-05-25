//
//  Nickname.swift
//  Licenta
//
//  Created by Paul Tiriteu on 19/03/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class User: Object {
    @objc dynamic var nickname: String = ""
    var difficultiesCompleted = List<Int>()
    var lastDifficultyCompletedGames = List<Int>()
    @objc dynamic var totalScore: Int = 0
}

//class IntObject: Object {
//    dynamic var value: Int = 0
//}
