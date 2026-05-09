//
//  ViewController.swift
//  sayHello
//
//  Created by Лев Алексеев on 10.05.2026.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameInputField: UITextField!
    
    @IBOutlet weak var helloUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helloUser.text = "🤠"
    }

    @IBAction func sayHello(_ sender: UIButton) {
        let text = nameInputField.text ?? "МИР"
        let name = text == "" ? "мистер никто" : text
        helloUser.text = "Привет, \(name)!"
        nameInputField.text = ""
    }
    
}

