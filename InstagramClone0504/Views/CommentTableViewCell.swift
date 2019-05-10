//
//  CommentTableViewCell.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/06.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var comment: Comment? {
        didSet{
            updateView()
        }
    }
    
    var user: UserModel? {
        didSet{
            setupUserInfo()
        }
    }
    
    func updateView() {
        commentLabel.text = comment?.commentText
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
        profileImageView.layer.cornerRadius = 18
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
