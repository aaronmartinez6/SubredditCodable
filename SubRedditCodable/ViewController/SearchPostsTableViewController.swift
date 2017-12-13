//
//  SearchPostsTableViewController.swift
//  SubRedditCodable
//
//  Created by Aaron Martinez on 12/11/17.
//  Copyright © 2017 Aaron Martinez. All rights reserved.
//

import UIKit

class SearchPostsTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let searchTerm = searchBar.text else { return }
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        PostController.shared.fetchPosts(by: searchTerm) {
            
            DispatchQueue.main.async {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                self.title = "r/\(searchTerm)"
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PostController.shared.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        
        let post = PostController.shared.posts[indexPath.row]
        
        PostController.shared.fetchThumbnail(at: post.thumbnailEndpoint) { (image) in
            DispatchQueue.main.async {
                cell.post = post
                if let currentIndexPath = self.tableView?.indexPath(for: cell),
                    currentIndexPath == indexPath {
                    cell.thumbnail = image
                } else {
                    print("Got image for now-reused cell")
                    return // Cell has been reused
                }
            }
        }
        return cell
    }
}
