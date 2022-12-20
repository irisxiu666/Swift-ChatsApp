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
import FacebookCore
import FacebookLogin
import FBSDKLoginKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        loginButton.delegate = self
        // loginButton.permissions = ["public_profile", "email"]
        view.addSubview(loginButton)
        
        // fbloginButton.addTarget(self, action: #selector(fbloginButtonTapped),for: .touchUpInside)
        
        //if let token = AccessToken.current,
        //!token.isExpired {
        //self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
        //}
        
    }
    
    /*
    @objc private func fbloginButtonTapped() {
        
        func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let credential = FacebookAuthProvider
                .credential(withAccessToken: AccessToken.current!.tokenString)
            
            Auth.auth().signIn(with: credential) {
                authResult, error in if let e = error {
                    print(e.localizedDescription)
                }else {
                    self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
                }
            }
            
        }
        
    }
       */
     @IBAction func LoginPressed(_ sender: UIButton) {
            
            guard let email = EmailTextField.text, let password = PasswordTextField.text,
                  !email.isEmpty, !password.isEmpty, password.count>=6 else {
                alterUserLoginError()
                return
            }
            
            if let email = EmailTextField.text, let password = PasswordTextField.text{
                
                
                FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let e = error{
                        print(e.localizedDescription)
                        
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
    
extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton, didCompleteWith result: FBSDKLoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with facebook")
            return
        }
        print("token")
        print(token)
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        // let credential = FacebookAuthProvider
        //  .credential(withAccessToken: AccessToken.current!.tokenString)
       
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
            guard self != nil else {
                return
            }

            guard authResult != nil, error == nil else {
                if let error = error {
                    print("Facebook credential login failed, MFA may be needed - \(error)")
                }
                return
            }

            print("Successfully logged user in")
            self?.performSegue(withIdentifier: Constants.loginSegue, sender: self)
        })
    }
        
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton) {
            
            // no operation
    }
    
}
