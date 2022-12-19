//
//  ViewController.swift
//  ChatsApp
//
//  Created by Admin on 6/27/22.
//

import UIKit


class WelcomeViewController: UIViewController {

   
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var index = 0
        titleLabel.text = ""
        
        for letter in Constants.appName {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(index), repeats: false, block: {(timer) in
                self.titleLabel.text?.append(letter)
            })
            
            index += 1
        }

    }


}

