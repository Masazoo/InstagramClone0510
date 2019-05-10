//
//  Post.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/05.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseAuth
class Post {
    
    var caption: String?
    var photoURL: String?
    var uid: String?
    var postId: String?
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
    
}
extension Post {
    static func transformPost(dict: [String: Any], key: String) -> Post {
        let post = Post()
        post.caption = dict["caption"] as? String
        post.photoURL = dict["photoURL"] as? String
        post.uid = dict["uid"] as? String
        post.postId = key
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        if let currentUserId = Auth.auth().currentUser?.uid {
            if post.likes != nil {
                post.isLiked = post.likes![currentUserId] != nil
            } else {
                post.isLiked = false
            }
        }
        return post
    }
}
