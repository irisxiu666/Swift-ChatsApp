//
//  ChatViewController.swift
//  ChatsApp
//
//  Created by Admin on 6/27/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FBSDKLoginKit


class ChatViewController: UIViewController {

    
    @IBOutlet weak var messageTextField: UITextField!
        
    @IBOutlet weak var tableView: UITableView!
    
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self // the line you forgot
        // Do any additional setup after loading the view.
        
        title = Constants.appName
    
        navigationItem.hidesBackButton = true
        // register to message cell
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages(){
         
        db.collection(Constants.FStore.collectionName).order(by: Constants.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print("There is an error when read data from database:\(e)")
            }else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[Constants.FStore.senderField] as? String, let messageBody = data[Constants.FStore.bodyField] as? String{
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            // reload data when fucntion is called
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                // scroll the screen to represent latest message.
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at:indexPath, at:.top, animated: true)
                            }
                        }
                        
                    }
                }
            }
        }
    }

    @IBAction func sendPressed(_ sender: UIButton) {
        
        guard let msg = messageTextField.text,
              !msg.isEmpty else {
            alterSendMessageError()
            return
        }
        
        if let messageBody = messageTextField.text,let messageSender = Auth.auth().currentUser?.email{
            
            db.collection(Constants.FStore.collectionName).addDocument(data: [Constants.FStore.senderField: messageSender, Constants.FStore.bodyField:messageBody, Constants.FStore.dateField: Date().timeIntervalSince1970]) { error in
                if let e =  error{
                    print("There is an error when add data to database:\(e)")
                }else{
                    print("Successfully saved data.")
                    // clear the sended message
                    DispatchQueue.main.async {
                        self.messageTextField.text = ""
                    }
                    
                }
            }
            
        }
        
        
        
    }
    
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        
        do{
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
            let loginManager = FBSDKLoginManager()
            try loginManager.logOut()
        }catch let signOutError as NSError{
            print("sign out error is:\(signOutError)")
        }

        
    }
    
}

extension ChatViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        // This is a message from current user.
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImage.isHidden = true
            cell.rightImage.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(red: 32, green: 181, blue: 9, alpha: 0.8)
        }
        // This is a message from another user.
        else{
            cell.leftImage.isHidden = false
            cell.rightImage.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(red: 9, green: 167, blue: 181, alpha: 0.5)
        }
        
        return cell
    }
    
    func alterSendMessageError() {
        let alert = UIAlertController(title: "Error", message: "Cannot send empty message", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
}
