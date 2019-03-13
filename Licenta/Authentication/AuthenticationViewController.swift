//
//  AuthenticationViewController.swift
//  Licenta
//
//  Created by Paul Tiriteu on 28/02/2019.
//  Copyright © 2019 Mobiversal. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get { return UIInterfaceOrientationMask.landscapeRight }
    }
    
    private let repository: AppRepository

    @IBAction func buttonAction(_ sender: Any) {
        if textField.text != "" {
            repository.setNickname(nickname: textField.text!)
            authorized()
        }
    }
    
    init(repository: AppRepository) {
        self.repository = repository
        super.init(nibName: "AuthenticationViewController", bundle: Bundle(for: AuthenticationViewController.self))
        super.loadViewIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureUI() {
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.9)

        titleLabel.text = "Who are you?"
        titleLabel.textColor = UIColor.black

        textField.autocapitalizationType = .words
        textField.placeholder = "Add a nickname..."
        
        button.layer.backgroundColor = UIColor.red.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setTitle("NEXT", for: .normal)
    }
    
    func authorized() {
        repository.toBullsEyeGame()
    }
}
