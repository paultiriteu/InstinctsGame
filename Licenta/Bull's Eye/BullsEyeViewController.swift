//
//  BullsEyeViewController.swift
//  Licenta
//
//  Created by Paul Tiriteu on 06/03/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import UIKit

class BullsEyeViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    private let repository: AppRepository
    
    init(repository: AppRepository) {
        self.repository = repository
        super.init(nibName: "BullsEyeViewController", bundle: Bundle(for: BullsEyeViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = repository.getNickname()
    }
}
