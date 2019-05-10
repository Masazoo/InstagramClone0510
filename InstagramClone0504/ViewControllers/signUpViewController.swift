//
//  signUpViewController.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/04.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit

class signUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
        signUpBtn.isEnabled = false
        handleTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    
    func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpBtn.setTitleColor(.white, for: .normal)
            signUpBtn.isEnabled = false
            return
        }
        
        signUpBtn.setTitleColor(.black, for: .normal)
        signUpBtn.isEnabled = true
    }
    
    func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("処理中...", interaction: false)
        if let profileImage = selectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
            AuthService.signUp(username: self.usernameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!, imageData: imageData, onSuccess: {
                self.performSegue(withIdentifier: "signUpToTabbarSegue", sender: nil)
                ProgressHUD.showSuccess("シェアに成功しました")
            }) { (error) in
                ProgressHUD.showError(error)
            }
        }else{
            ProgressHUD.showSuccess("写真を選択してください")
        }
    }

    @IBAction func dissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
extension signUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finidh Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
