//
//  CommentViewController.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/06.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var constraintToButtom: NSLayoutConstraint!
    
    var postId: String!
    var comments = [Comment]()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        handleTextField()
        sendButtonDefault()
        
        loadComments()
        
        // keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // textFieldとkeyboardの設定
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func keyboardWillShow(_ notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3) {
            self.constraintToButtom.constant = -(keyboardFrame!.height)
            self.view.layoutIfNeeded()
        }
    }
    func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintToButtom.constant = 0
            print(self.constraintToButtom.constant)
            self.view.layoutIfNeeded()
        }
    }
    
    
    func loadComments() {
        let postCommentRef = Api.Post_Comment.REF_POST_COMMENT.child(postId)
        postCommentRef.observe(.childAdded, with: { (DataSnapshot) in
            Api.Comment.observeComments(commentId: DataSnapshot.key, completion: { (comment) in
                self.fetchUser(uid: comment.uid!, completion: {
                    self.comments.append(comment)
                    self.tableView.reloadData()
                })
            })
        })
    }
    func fetchUser(uid: String, completion: @escaping () -> Void) {
        Api.User.observeUser(uid: uid) { (user) in
            self.users.append(user)
            completion()
        }
    }
    

    
    @IBAction func sendComment_TouchUpInside(_ sender: Any) {
        Api.Comment.sendCommentToDatabase(comment: self.commentTextField.text!, postId: postId) {
            self.clean()
        }
    }
    
    func clean() {
        self.commentTextField.text = ""
    }
    
    // tabの設定
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // textFieldとbutton周りの設定
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    func textFieldDidChange() {
        guard let comment = commentTextField.text, !comment.isEmpty else {
            sendButtonDefault()
            return
        }
        sendBtn.setTitleColor(.black, for: .normal)
        sendBtn.isEnabled = true
    }
    
    // sendButtonのデフォルト設定
    func sendButtonDefault() {
        sendBtn.setTitleColor(.gray, for: .normal)
        sendBtn.isEnabled = false
    }
    
    
}
extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comment = comment
        cell.user = user
        return cell
    }
    
    
}
