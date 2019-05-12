//
//  PeopleTableViewCell.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/10.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
protocol PeopleTableViewCellDelegate {
    func goToProfileUserVC(userId: String)
}

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var delegate: PeopleTableViewCellDelegate?
    
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
        
        if user!.isFollowing! {
            configureUnFollowAction()
        }else{
            configureFollowAction()
        }
        
    }
    
    func configureFollowAction() {
        followBtn.setTitle("フォローする", for: .normal)
        followBtn.addTarget(self, action: #selector(self.followAction), for: .touchUpInside)
    }
    
    func configureUnFollowAction() {
        followBtn.setTitle("フォロー中", for: .normal)
        followBtn.addTarget(self, action: #selector(self.unFollowAction), for: .touchUpInside)
    }
    
    func followAction() {
        if !user!.isFollowing! {
            Api.Follow.followAction(userId: user!.uid!)
            configureUnFollowAction()
            user!.isFollowing! = true
        }
    }
    
    func unFollowAction() {
        if user!.isFollowing! {
            Api.Follow.unFollowAction(userId: user!.uid!)
            configureFollowAction()
            user!.isFollowing! = false
        }
    }
    
    
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 30
        
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectNameLabel))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
    }
    
    func handleSelectNameLabel() {
        delegate?.goToProfileUserVC(userId: user!.uid!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
