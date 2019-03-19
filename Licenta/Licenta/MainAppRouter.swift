//
//  MainAppRouter.swift
//  Licenta
//
//  Created by Paul Tiriteu on 28/02/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import Foundation
import UIKit

class MainAppRouter {
    private var navController: UINavigationController?
    
    init() {
        
    }
    
    func getStartScreen() -> UINavigationController {
        let repository = AppRepository(router: self)
        let vc = AuthenticationViewController(repository: repository)
        self.navController = UINavigationController(rootViewController: vc)
        navController?.setNavigationBarHidden(true, animated: true)
        
        return navController!
    }
    
    func toBullsEyeGame(nickname: String) {
        let repository = AppRepository(router: self)
        let vc = BullsEyeViewController(repository: repository)
        navController!.pushViewController(vc, animated: true)
    }
    
    func toLevelsView(nickname: String) {
        let repository = AppRepository(router: self)
        let vc = LevelsViewController(repository: repository)
        navController!.pushViewController(vc, animated: true)
    }
    
    func popViewController() {
        
    }
}
