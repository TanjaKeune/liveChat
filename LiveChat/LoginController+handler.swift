//
//  LoginController+handler.swift
//  LiveChat
//
//  Created by Tanja Keune on 9/11/17.
//  Copyright © 2017 SUGAPP. All rights reserved.
//

import UIKit
import Firebase

extension LoginController {
    
    func handleSelectProfileImageView(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImageView.image = originalImage
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text  else {
            
            print("form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                
                //                function to take the error description and present it in alert controller
                
                //                self.alertMessage(title: "Error", message: "Try again")
                print(error)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //            Save the users in Firebase DB
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                
                storageRef.putData(uploadData, metadata: nil) {
                    (metadata, error) in
                    
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["name": name, "email": email, "profileImageURL": profileImageURL]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                    }
                }
            }
            //            jump on message view controller
        }
    }

    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        
        let ref = Database.database().reference(fromURL: "https://funyou-9d1cc.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err)
                return
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
}


