//
//  HeaderCollectionReusableView.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/10.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
protocol HeaderCollectionReusableViewDelegate {
    func updateFollowBtn(user: UserModel)
}

class HeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    var delegate: HeaderCollectionReusableViewDelegate?
    
    var user: UserModel? {
        didSet{
            setupUserInfo()
        }
    }
    
    func setupUserInfo() {
        nameLabel.text = user?.username
        if let profileUrlString = user?.profileImageURL {
            let profileImageUrl = URL(string: profileUrlString)
            profileImageView.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        Api.MyPosts.fetchMyPostsCount(userId: user!.uid!) { (count) in
            self.myPostCount.text = count.description
        }
        
        Api.Follow.fetchFollowingCount(userId: user!.uid!) { (count) in
            self.followingCount.text = count.description
        }
        
        Api.Follow.fetchFollowerCount(userId: user!.uid!) { (count) in
            self.followerCount.text = count.description
        }
        
        
        if user?.uid == Api.User.CURRENT_USER?.uid {
            editBtn.setTitle("編集する", for: .normal)
        }else{
            updateStateEditBtn()
        }
        
    }
    
    func updateStateEditBtn() {
        if user!.isFollowing! {
            configureUnFollowAction()
        }else{
            configureFollowAction()
        }
    }
    
    func configureFollowAction() {
        editBtn.setTitle("フォローする", for: .normal)
        editBtn.addTarget(self, action: #selector(self.followAction), for: .touchUpInside)
    }
    
    func configureUnFollowAction() {
        editBtn.setTitle("フォロー中", for: .normal)
        editBtn.addTarget(self, action: #selector(self.unFollowAction), for: .touchUpInside)
    }
    
    func followAction() {
        if !user!.isFollowing! {
            Api.Follow.followAction(userId: user!.uid!)
            configureUnFollowAction()
            user!.isFollowing! = true
            delegate?.updateFollowBtn(user: user!)
        }
    }
    
    func unFollowAction() {
        if user!.isFollowing! {
            Api.Follow.unFollowAction(userId: user!.uid!)
            configureFollowAction()
            user!.isFollowing! = false
            delegate?.updateFollowBtn(user: user!)
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
    }
}
