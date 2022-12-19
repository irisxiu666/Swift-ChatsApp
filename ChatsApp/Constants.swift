//
//  Constants.swift
//  ChatsApp
//
//  Created by Admin on 6/29/22.
//

import Foundation

struct Constants {
    static let appName = "⚡️ChatsApp"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
