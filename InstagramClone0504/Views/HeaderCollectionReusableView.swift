//
//  HeaderCollectionReusableView.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/10.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
    }
}
