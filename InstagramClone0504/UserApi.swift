//
//  UserApi.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/05.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UserApi {
    
    var REF_USERS = Database.database().reference().child("users")
    
    var CURRENT_USER: User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }
        return nil
    }
    
    func observeUsers(completion: @escaping (UserModel) -> Void) {
        REF_USERS.observe(.childAdded, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict)
                completion(user)
            }
        })
    }
    
    func observeUser(uid: String, completion: @escaping (UserModel) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict)
                completion(user)
            }
        })
    }
    
    func observeCurrentUser(completion: @escaping (UserModel) -> Void) {
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        REF_USERS.child(currentUserId).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict)
                completion(user)
            }
        })
    }
}
