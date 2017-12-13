//
//  PostTableViewCell.swift
//  SubRedditCodable
//
//  Created by Aaron Martinez on 12/11/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var upvoteCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!

    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    var thumbnail: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        
        guard let post = post else { return }
        
        if let thumbnail = thumbnail {
            thumbnailImageView.image = thumbnail
        } else {
            thumbnailImageView.image = #imageLiteral(resourceName: "no-image-available")
        }
        
        titleLabel.text = post.title
        upvoteCountLabel.text = "Number of upvotes: \(post.numberOfUpvotes)"
        commentsCountLabel.text = "Number of comments: \(post.numberOfComments)"
    }
}
