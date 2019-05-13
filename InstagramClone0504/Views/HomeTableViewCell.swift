//
//  HomeTableViewCell.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/05.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import SDWebImage
protocol HomeTableViewCellDelegate {
    func goToCommentVC(postId: String)
    func goToProfileUserVC(userId: String)
}

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var likeCountBtn: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var delegate: HomeTableViewCellDelegate?
    
    var post: Post? {
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
        captionLabel.text = post?.caption
        if let photoUrlString = post?.photoURL {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
        self.updateLike(post: self.post!)
    }
    
    func setupUserInfo() {
        nameLabel.text = user?.username
        if let profileUrlString = user?.ProfileImageUrl {
            let profileImageUrl = URL(string: profileUrlString)
            profileImageView.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    
    func updateLike(post: Post) {
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
        
        guard let count = post.likeCount else {
            return
        }
        if count != 0 {
            likeCountBtn.setTitle("\(count) likes", for: .normal)
        } else {
            likeCountBtn.setTitle("最初のライクを押してね！", for: .normal)
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 18
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        
        let tapGestureForCommentImageView = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectCommentImageView))
        commentImageView.addGestureRecognizer(tapGestureForCommentImageView)
        commentImageView.isUserInteractionEnabled = true
        let tapGestureForLikeImageView = UITapGestureRecognizer(target: self, action: #selector(self.likeImageView_TouchUpInside))
        likeImageView.addGestureRecognizer(tapGestureForLikeImageView)
        likeImageView.isUserInteractionEnabled = true
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectNameLabel))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
    }
    
    func handleSelectCommentImageView() {
        delegate?.goToCommentVC(postId: post!.postId!)
    }
    
    func handleSelectNameLabel() {
        delegate?.goToProfileUserVC(userId: post!.uid!)
    }
    
    func likeImageView_TouchUpInside() {
        Api.Post.incrementLikeCount(withId: self.post!.postId!, onSuccess: { (post) in
            self.updateLike(post: post)
            self.post?.likes = post.likes
            self.post?.likeCount = post.likeCount
            self.post?.isLiked = post.isLiked
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
