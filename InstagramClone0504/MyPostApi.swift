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
}
