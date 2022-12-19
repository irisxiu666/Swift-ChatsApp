//
//  LoginViewController.swift
//  ChatsApp
//
//  Created by Admin on 6/27/22.
//


import FirebaseAuth
import FirebaseCore
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBLoginButton()
                loginButton.center = view.center
        loginButton.permissions = ["public_profile", "email"]
                view.addSubview(loginButton)
        
        if let token = AccessToken.current,
                !token.isExpired {
                ChatViewController()
            }
        
    }



    @IBAction func LoginPressed(_ sender: UIButton) {
        
        guard let email = EmailTextField.text, let password = PasswordTextField.text,
              !email.isEmpty, !password.isEmpty, password.count>=6 else {
            alterUserLoginError()
            return
        }
        
        if let email = EmailTextField.text, let password = PasswordTextField.text{
            
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                    self.alterUserLoginError()
                    
                }else{
                    self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
                }
             
            }
            
        }
        
    }
    
    func alterUserLoginError() {
        let alert = UIAlertController(title: "Error", message: "Please enter correct information to log in", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
    
}
