//
//  SettingTableViewController.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/12.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import SDWebImage
protocol SettingTableViewControllerDelegate {
    func updateUserInfo()
}

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var delegate: SettingTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsSelection = false
        emailTextField.delegate = self
        nameTextField.delegate = self
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
        fetchCurrentUser()
    }

    func fetchCurrentUser() {
        Api.User.observeCurrentUser { (user) in
            self.nameTextField.text = user.username
            self.emailTextField.text = user.email
            if let profileUrlString = user.ProfileImageUrl {
                let profileImageUrl = URL(string: profileUrlString)
                self.profileImageView.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "placeholderImg"))
            }
        }
    }
    
    
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("処理中...", interaction: false)
        if let profileImage = profileImageView.image, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
            AuthService.updateUserInfo(email: emailTextField.text!, username: nameTextField.text!, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("保存に成功しました")
                self.delegate?.updateUserInfo()
            }) { (error) in
                ProgressHUD.showError(error)
            }
        }else{
            ProgressHUD.showSuccess("写真を選択してください")
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
    
    
    func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
}
extension SettingTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finidh Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
extension SettingTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.emailTextField.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        return true
    }
}
