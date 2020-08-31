//
//  DatabaseManeger.swift
//  messenger
//
//  Created by kobayashi emino on 2020/08/31.
//  Copyright © 2020 kobayashi emino. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManeger {
    static let shared = DatabaseManeger()
    private let database = Database.database().reference()
}

// MARK: -Account Management

extension DatabaseManeger {
    
    public func userExists(with email: String, completion: @escaping (Bool) -> Void) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "firstname": user.firstname,
            "lastname": user.lastname
        ])
    }
}

struct ChatAppUser {
    let firstname: String
    let lastname: String
    let emailAdress: String
    
    var safeEmail: String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
