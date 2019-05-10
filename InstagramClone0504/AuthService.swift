//
//  AuthService.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/04.
//  Copyright © 2019 mt. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AuthService {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (AuthDataResult, Error) in
            if Error != nil {
                onError(Error!.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (AuthDataResult, Error) in
            if Error != nil {
                onError(Error!.localizedDescription)
                return
            }
            let uid = AuthDataResult?.user.uid
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)
            storageRef.putData(imageData, metadata: nil, completion: { (StorageMetadata, Error) in
                if Error != nil {
                    print(Error!.localizedDescription)
                    return
                }
                storageRef.downloadURL(completion: { (URL, Error) in
                    if Error != nil {
                        print(Error!.localizedDescription)
                        return
                    }
                    let profileImageURL = URL?.absoluteString
                    setUserInfomation(uid: uid!, username: username, email: email, profileImageURL: profileImageURL!, onSuccess: onSuccess)
                })
            })
        }
    }
    static func setUserInfomation(uid: String, username: String, email: String, profileImageURL: String, onSuccess: @escaping () -> Void) {
        let usersRef = Database.database().reference().child("users")
        let newUserRef = usersRef.child(uid)
        newUserRef.setValue(["username": username, "email": email, "profileImageURL": profileImageURL])
        onSuccess()
    }
    
    static func logout(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        do {
            try Auth.auth().signOut()
            onSuccess()
        } catch let logoutError {
            onError(logoutError.localizedDescription)
        }
    }
}
