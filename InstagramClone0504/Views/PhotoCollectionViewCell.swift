//
//  PhotoCollectionViewCell.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/10.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
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
    }
}
