//
//  PhotoCollectionViewCell.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/10.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
protocol PhotoCollectionViewCellDelegate {
    func goToDtailVC(postId: String)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var delegate: PhotoCollectionViewCellDelegate?
    
    
    var post: Post? {
        didSet{
            updateView()
        }
    }
    
    func updateView() {
        if let photoUrlString = post?.photoURL {
            let photoUrl = URL(string: photoUrlString)
            photoImageView.sd_setImage(with: photoUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        
        let tapGestureForPhotoImageView = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhotoImageView))
        photoImageView.addGestureRecognizer(tapGestureForPhotoImageView)
        photoImageView.isUserInteractionEnabled = true
    }
    
    func handleSelectPhotoImageView() {
        delegate?.goToDtailVC(postId: post!.postId!)
    }
    
}
