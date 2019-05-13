//
//  PeopleViewController.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/10.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.allowsSelection = false
        
//        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.users.removeAll()
        fetchUser()
    }
    
    func fetchUser() {
        Api.User.observeUsers { (user) in
            Api.Follow.isFollowing(userId: user.uid!, completion: { (value) in
                user.isFollowing = value
                self.users.append(user)
                self.tableView.reloadData()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PeopleToProfileUserSegue" {
            let userId = sender as! String
            let profileUserVC = segue.destination as! ProfileUserViewController
            profileUserVC.userId = userId
            profileUserVC.delegate = self
        }
    }

}
extension PeopleViewController: UITableViewDataSource {
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
extension PeopleViewController: PeopleTableViewCellDelegate {
    func goToProfileUserVC(userId: String) {
        self.performSegue(withIdentifier: "PeopleToProfileUserSegue", sender: userId)
    }
}
extension PeopleViewController: HeaderCollectionReusableViewDelegate {
    func updateFollowBtn(user: UserModel) {
        for u in self.users {
            if u.uid == user.uid {
                u.isFollowing = user.isFollowing
                tableView.reloadData()
            }
        }
    }
}
