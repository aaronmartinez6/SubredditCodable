//
//  PostController.swift
//  SubRedditCodable
//
//  Created by Aaron Martinez on 12/11/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class PostController {
    
    static let shared = PostController()
    
    static let baseURL = URL(string: "https://www.reddit.com/r")!
    
    var posts: [Post] = []
    
    func fetchPosts(by searchTerm: String, completion: @escaping() -> Void) {
        
        let subredditURL = PostController.baseURL.appendingPathComponent(searchTerm.lowercased()).appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: subredditURL) { (data, _, error) in
            
            if let error = error {
                print("There was an error in \(#function). Error: \(error)")
                completion()
                return
            }
            
            guard let data = data else { completion(); return }
            
            do {
                let decoder = JSONDecoder()
                let jsonDictionary = try decoder.decode(JSONDictionary.self, from: data)
                let postsWithoutImages = jsonDictionary.data.children.flatMap( { $0.post })
                
                self.posts = postsWithoutImages
                completion()
            } catch let error {
                print("There was an error decoding the json data. Error: \(error.localizedDescription)")
                completion()
                return
            }
        }.resume()
    }
    
    func fetchThumbnail(at urlString: String, completion: @escaping(UIImage?) -> Void) {
        
        guard let url = URL(string: urlString) else { completion(nil); return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                print("There was an error fetching the post's thumbnail: Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { completion(nil); return }
            completion(image)
            }.resume()
    }
}
