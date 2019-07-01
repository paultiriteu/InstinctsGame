//
//  FinalScreenViewController.swift
//  TrustYourInstinct
//
//  Created by Paul on 28/06/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import UIKit

class FinalScreenViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var thanksButton: UIButton!
    
    private let repository: AppRepository
    
    @IBAction func buttonAction(_ sender: Any) {
        repository.toLevelsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thanksButton.setTitle("Thanks!", for: .normal)
        thanksButton.layer.cornerRadius = 10
        
        label.text = "Congratulations \(repository.getNickname())!\nYou trusted your instinct and you won!"
        label.textColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 30)
    }
    
    init(repository: AppRepository) {
        self.repository = repository
        
        super.init(nibName: "FinalScreenViewController", bundle: Bundle(for: FinalScreenViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
