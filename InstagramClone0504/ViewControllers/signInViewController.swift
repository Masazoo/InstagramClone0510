//
//  signInViewController.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/04.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import FirebaseAuth

class signInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInBtn.isEnabled = false
        handleTextField()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Api.User.CURRENT_USER != nil {
            self.performSegue(withIdentifier: "signInToTabbarSegue", sender: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    
    func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signInBtn.setTitleColor(.white, for: .normal)
            signInBtn.isEnabled = false
            return
        }
        
        signInBtn.setTitleColor(.black, for: .normal)
        signInBtn.isEnabled = true
    }
    
    

    
    @IBAction func signIn_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("処理中...", interaction: false)
        AuthService.signIn(email: self.emailTextField.text!, password: self.passwordTextField.text!, onSuccess: {
            self.performSegue(withIdentifier: "signInToTabbarSegue", sender: nil)
            ProgressHUD.showSuccess("ログインに成功しました")
        }) { (error) in
            ProgressHUD.showError(error)
        }
    }
    

}
