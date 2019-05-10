//
//  CameraViewController.swift
//  InstagramClone0504
//
//  Created by mt on 2019/05/04.
//  Copyright © 2019 mt. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class CameraViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareBtn: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handlePost()
    }
    
    func handlePost() {
        if selectedImage != nil {
            shareBtn.isEnabled = true
            shareBtn.backgroundColor = .black
        } else {
            shareBtn.isEnabled = false
            shareBtn.backgroundColor = .gray
        }
    }
    
    func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func shareBtn_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("処理中...", interaction: false)
        if let photo = selectedImage, let imageData = UIImageJPEGRepresentation(photo, 0.1) {
            HelperService.uploadDataToServer(caption: self.captionTextView.text!, imageData: imageData) {
                self.tabBarController?.selectedIndex = 0
                self.clean()
            }
        }else{
            ProgressHUD.showSuccess("写真を選択してください")
        }
    }
    
    func clean() {
        self.photo.image = UIImage(named: "Placeholder-image")
        self.captionTextView.text = ""
        self.selectedImage = nil
    }
    
    
}
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finidh Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            photo.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

