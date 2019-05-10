//
//  FollowApi.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/10.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowApi {
    
    var REF_FOLLOWING = Database.database().reference().child("following")
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    
    
    
    func followAction(userId: String) {
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(userId).setValue(true)
        REF_FOLLOWERS.child(userId).child(Api.User.CURRENT_USER!.uid).setValue(true)
    }
    
    func unFollowAction(userId: String) {
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(userId).setValue(NSNull())
        REF_FOLLOWERS.child(userId).child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
    }
    
    
    func isFollowing(userId: String, completion: @escaping (Bool) -> Void) {
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(userId).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let _ = DataSnapshot.value as? NSNull {
                completion(false)
            }else{
                completion(true)
            }
        })
    }
}
