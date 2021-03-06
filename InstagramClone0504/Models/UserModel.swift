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
    var ProfileImageUrl: String?
    var uid: String?
    var isFollowing: Bool?
    
}
extension UserModel {
    static func transformUser(dict: [String: Any], uid: String) -> UserModel {
        let user = UserModel()
        user.email = dict["email"] as? String
        user.username = dict["username"] as? String
        user.ProfileImageUrl = dict["ProfileImageUrl"] as? String
        user.uid = uid
        
        return user
    }
}
