//
//  ProfileUserViewController.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/10.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class ProfileUserViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userId = ""
    var user: UserModel!
    var posts = [Post]()
    var delegate: HeaderCollectionReusableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchUser()
        loadPost()
    }
    
    func fetchUser() {
        Api.User.observeUser(uid: self.userId) { (user) in
            Api.Follow.isFollowing(userId: user.uid!, completion: { (value) in
                user.isFollowing = value
                self.navigationItem.title = user.username
                self.user = user
                self.collectionView.reloadData()
            })
        }
    }
    
    func loadPost() {
        Api.MyPosts.REF_MYPOSTS.child(self.userId).observe(.childAdded, with: { (DataSnapshot) in
            Api.Post.observePost(postId: DataSnapshot.key, completion: { (post) in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        })
    }
    
    
}
extension ProfileUserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
        if let user = self.user {
            headerCell.user = user
            headerCell.delegate = self.delegate
        }
        return headerCell
        
    }
}
extension ProfileUserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.width / 3 - 1)
    }
}


