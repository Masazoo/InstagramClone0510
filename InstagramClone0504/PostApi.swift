//
//  PostApi.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/05.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class PostApi {
    
    var REF_POSTS = Database.database().reference().child("posts")
    
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.observe(.childAdded, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let post = Post.transformPost(dict: dict, key: DataSnapshot.key)
                completion(post)
            }
        })
    }
    
    func observePost(postId: String, completion: @escaping (Post) -> Void) {
        REF_POSTS.child(postId).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let post = Post.transformPost(dict: dict, key: DataSnapshot.key)
                completion(post)
            }
        })
    }
    
    
    func incrementLikeCount(withId id: String, onSuccess: @escaping (Post) -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        let postRef = REF_POSTS.child(id)
        postRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                var likes : Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject
                post["likes"] = likes as AnyObject
                
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                onError(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.transformPost(dict: dict, key: snapshot!.key)
                onSuccess(post)
            }
        }
    }
    
}

