//
//  Api.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/05.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
struct Api {
    static var User = UserApi()
    static var Post = PostApi()
    static var Comment = CommentApi()
    static var Post_Comment = Post_CommentApi()
    static var MyPosts = MyPostApi()
}

