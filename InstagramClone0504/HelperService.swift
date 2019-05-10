//
//  HelperService.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/05.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
class HelperService {
    
    static func uploadDataToServer(caption: String, imageData: Data, onSuccess: @escaping () -> Void) {
        let photoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(photoIdString)
        
        storageRef.putData(imageData, metadata: nil, completion: { (StorageMetadata, Error) in
            if Error != nil {
                return
            }
            storageRef.downloadURL(completion: { (URL, Error) in
                if Error != nil {
                    return
                }
                let photoURL = URL?.absoluteString
                self.sendDataToDatabase(caption: caption, photoURL: photoURL!, onSuccess: onSuccess)
            })
        })
    }
    
    static func sendDataToDatabase(caption: String, photoURL: String, onSuccess: @escaping () -> Void) {
        let postsRef = Database.database().reference().child("posts")
        let newPostId = postsRef.childByAutoId().key
        let newPostRef = postsRef.child(newPostId!)
        
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        
        newPostRef.setValue(["caption": caption, "photoURL": photoURL, "uid": currentUserId, "likeCount": 0]) { (Error, DatabaseReference) in
            if Error != nil {
                ProgressHUD.showError(Error!.localizedDescription)
            }
            
            let myPostsRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child(newPostId!)
            myPostsRef.setValue(true, withCompletionBlock: { (Error, DatabaseReference) in
                if Error != nil {
                    ProgressHUD.showError(Error!.localizedDescription)
                }
            })
        }
        ProgressHUD.showSuccess("投稿が成功しました")
        onSuccess()
    }
}
