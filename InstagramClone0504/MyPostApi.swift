//
//  MyPostApi.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/10.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct MyPostApi {
    
    var REF_MYPOSTS = Database.database().reference().child("myPosts")
    
    
    func fetchMyPostsCount(userId: String, completion: @escaping (Int) -> Void) {
        REF_MYPOSTS.child(userId).observe(.value, with: { (DataSnapshot) in
            let count = Int(DataSnapshot.childrenCount)
            completion(count)
        })
    }
}
