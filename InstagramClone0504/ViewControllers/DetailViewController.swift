//
//  DetailViewController.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/13.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var postId = ""
    var post = Post()
    var user = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        loadPost()
    }
    
    
    func loadPost() {
        Api.Post.observePost(postId: postId) { (post) in
            self.fetchUser(uid: post.uid!, completion: {
                self.post = post
                self.tableView.reloadData()
            })
        }
    }
    func fetchUser(uid: String, completion: @escaping () -> Void) {
        Api.User.observeUser(uid: uid) { (user) in
            self.user = user
            completion()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailToCommentSegue" {
            let postId = sender as! String
            let commentVC = segue.destination as! CommentViewController
            commentVC.postId = postId
        }
        
        if segue.identifier == "DetailToProfileUserSegue" {
            let userId = sender as! String
            let profileUserVC = segue.destination as! ProfileUserViewController
            profileUserVC.userId = userId
        }
    }
}
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
}
extension DetailViewController: HomeTableViewCellDelegate {
    func goToCommentVC(postId: String) {
        self.performSegue(withIdentifier: "DetailToCommentSegue", sender: postId)
    }
    
    func goToProfileUserVC(userId: String) {
        self.performSegue(withIdentifier: "DetailToProfileUserSegue", sender: userId)
    }
}

