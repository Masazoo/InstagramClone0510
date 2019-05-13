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
                    let ProfileImageUrl = URL?.absoluteString
                    setUserInfomation(uid: uid!, username: username, email: email, ProfileImageUrl: ProfileImageUrl!, onSuccess: onSuccess)
                })
            })
        }
    }
    static func setUserInfomation(uid: String, username: String, email: String, ProfileImageUrl: String, onSuccess: @escaping () -> Void) {
        let usersRef = Database.database().reference().child("users")
        let newUserRef = usersRef.child(uid)
        newUserRef.setValue(["username": username, "email": email, "ProfileImageUrl": ProfileImageUrl])
        onSuccess()
    }
    
    
    
    
    static func updateUserInfo(email: String, username: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        Api.User.CURRENT_USER?.updateEmail(to: email, completion: { (Error) in
            if Error != nil {
                onError(Error!.localizedDescription)
            }else{
                let uid = Api.User.CURRENT_USER?.uid
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
                        let ProfileImageUrl = URL?.absoluteString
                        self.updateaDatabase(email: email, username: username, ProfileImageUrl: ProfileImageUrl!, onSuccess: onSuccess, onError: onError)
                    })
                })
            }
        })
    }
    static func updateaDatabase(email: String, username: String, ProfileImageUrl: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        let dict = ["username": username, "email": email, "ProfileImageUrl": ProfileImageUrl]
        Api.User.REF_CURRENT_USER?.updateChildValues(dict, withCompletionBlock: { (Error, DatabaseReference) in
            if Error != nil {
                onError(Error!.localizedDescription)
            } else {
                onSuccess()
            }
        })
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
