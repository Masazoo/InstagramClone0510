//
//  SearchViewController.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/10.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        fetchUser()
    }
    
    func fetchUser() {
        Api.User.observeUsers { (user) in
            Api.Follow.isFollowing(userId: user.uid!, completion: { (value) in
                user.isFollowing = value
                guard Api.User.CURRENT_USER?.uid != user.uid else {
                    return
                }
                self.users.append(user)
                self.tableView.reloadData()
            })
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToProfileUserSegue" {
            let userId = sender as! String
            let profileUserVC = segue.destination as! ProfileUserViewController
            profileUserVC.userId = userId
            profileUserVC.delegate = self
        }
    }
    
    
}
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        cell.delegate = self
        return cell
    }
}
extension SearchViewController: PeopleTableViewCellDelegate {
    func goToProfileUserVC(userId: String) {
        self.performSegue(withIdentifier: "SearchToProfileUserSegue", sender: userId)
    }
}
extension SearchViewController: HeaderCollectionReusableViewDelegate {
    func updateFollowBtn(user: UserModel) {
        for u in self.users {
            if u.uid == user.uid {
                u.isFollowing = user.isFollowing
                tableView.reloadData()
            }
        }
    }
}

