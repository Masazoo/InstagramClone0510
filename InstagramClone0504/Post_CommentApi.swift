//
//  Post_CommentApi.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/08.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase
struct Post_CommentApi {
    var REF_POST_COMMENT = Database.database().reference().child("post-comment")
}
