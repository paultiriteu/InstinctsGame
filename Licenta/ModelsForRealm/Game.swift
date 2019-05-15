//
//  Game.swift
//  Licenta
//
//  Created by Paul on 11/05/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import Foundation
import RealmSwift

class Game: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
}
