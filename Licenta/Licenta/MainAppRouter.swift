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
    private let navController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navController = navigationController
    }
    
    func toBullsEyeGame(nickname: String) {
        let repository = AppRepository(nickname: nickname, router: self)
        let vc = BullsEyeViewController(repository: repository)
        navController.pushViewController(vc, animated: true)
    }
    
    func popViewController() {
        
    }
//    func toAuthenticationScreen(navigationController: UINavigationController) {
//        let vc = AuthenticationViewController()
//        navigationController.pushViewController(vc, animated: true)
//    }
}
