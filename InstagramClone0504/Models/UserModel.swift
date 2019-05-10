//
//  UserModel.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/05.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
class UserModel {
    
    var email: String?
    var username: String?
    var profileImageURL: String?
    
}
extension UserModel {
    static func transformUser(dict: [String: Any]) -> UserModel {
        let user = UserModel()
        user.email = dict["email"] as? String
        user.username = dict["username"] as? String
        user.profileImageURL = dict["profileImageURL"] as? String
        
        return user
    }
}
