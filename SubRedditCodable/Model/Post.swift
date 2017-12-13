//
//  Post.swift
//  SubRedditCodable
//
//  Created by Aaron Martinez on 12/11/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

struct JSONDictionary: Decodable {
    
    let data: DataDictionary
    
    struct DataDictionary: Decodable {
        
        let children: [PostDictionary]
        
        struct PostDictionary: Decodable {
            
            enum CodingKeys: String, CodingKey {
                case post = "data"
            }
            
            let post: Post
        }
    }
}

struct Post: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case thumbnailEndpoint = "thumbnail"
        case numberOfUpvotes = "ups"
        case numberOfComments = "num_comments"
    }
    
    let title: String
    let thumbnailEndpoint: String
    let numberOfUpvotes: Int
    let numberOfComments: Int
}
