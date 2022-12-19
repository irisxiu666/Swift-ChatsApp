//
//  WelcomeViewController.swift
//  ChatsApp
//
//  Created by Admin on 6/27/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var EmailTextField2: UITextField!

    @IBOutlet weak var PasswordTextField2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func registerPressed(_ sender: UIButton) {
        guard let email = EmailTextField2.text, let password = PasswordTextField2.text,
              !email.isEmpty, !password.isEmpty else {
            alterUserRegisterError()
            return
        }
        
        if password.count<=6 {
            InvalidPasswordError()
            return
        }
        
        if let email = EmailTextField2.text,let password = PasswordTextField2.text{
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let e = error{
                    print(e)
                }else{
                    // navigate to chat room
                    self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
                }
        
            }
        }
    }
    
    func alterUserRegisterError() {
        let alert = UIAlertController(title: "Error", message: "Please enter all information to register", preferredStyle:.alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
    func InvalidPasswordError() {
        let alert = UIAlertController(title: "Error", message: "Password contains at least six characters", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
}

