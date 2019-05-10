//
//  CommentApi.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/06.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentApi {
    
    let commentsRef = Database.database().reference().child("comments")
    
    
    func observeComments(commentId: String, completion: @escaping (Comment) -> Void) {
        commentsRef.child(commentId).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any] {
                let comment = Comment.transformPost(dict: dict)
                completion(comment)
            }
        })
    }
    
    
    func sendCommentToDatabase(comment: String, postId: String, onSuccess: @escaping () -> Void) {
        // comments
        let newCommentId = commentsRef.childByAutoId().key
        let newCommentRef = commentsRef.child(newCommentId!)
        
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        
        newCommentRef.setValue(["commentText": comment, "uid": currentUserId]) { (Error, DatabaseReference) in
            // postComments
            let postCommentRef = Database.database().reference().child("post-comment").child(postId).child(newCommentId!)
            postCommentRef.setValue(true)
        }
        onSuccess()
    }
}
