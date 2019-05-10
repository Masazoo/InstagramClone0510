
//
//  HomeViewController.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/04.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var users = [UserModel]()
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        loadPost()
    }
    
    func loadPost() {
        Api.Post.observePosts { (post) in
            self.fetchUser(uid: post.uid!, completion: {
                self.posts.append(post)
                self.tableView.reloadData()
            })
        }
    }
    func fetchUser(uid: String, completion: @escaping () -> Void) {
        Api.User.observeUser(uid: uid) { (user) in
            self.users.append(user)
            completion()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToCommentSegue" {
            let postId = sender as! String
            let commentVC = segue.destination as! CommentViewController
            commentVC.postId = postId
        }
    }
    
    
    @IBAction func logout_TouchUpInside(_ sender: Any) {
        AuthService.logout(onSuccess: {
            let stroyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = stroyboard.instantiateViewController(withIdentifier: "signInViewController")
            self.present(signInVC, animated: true, completion: nil)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
}
extension HomeViewController: HomeTableViewCellDelegate {
    func goToCommentVC(postId: String) {
        self.performSegue(withIdentifier: "HomeToCommentSegue", sender: postId)
    }
    
    
}
