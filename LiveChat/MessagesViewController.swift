//
//  ViewController.swift
//  LiveChat
//
//  Created by Tanja Keune on 9/4/17.
//  Copyright © 2017 SUGAPP. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "newMsg")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        checkIfUserIsLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        checkIfUserIsLoggedIn()
    }
    
    
    func handleNewMessage() {
        let newMessageCont = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageCont)
        present(navController, animated: true, completion: nil)
        
    }
    
    func checkIfUserIsLoggedIn() {
        
        if Auth.auth().currentUser?.uid == nil {
            
            perform(#selector(handleLogout), with: nil, afterDelay: 0.0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
//                print(snapshot)
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    self.navigationItem.title = dictionary["name"] as? String
                    
                }
                
            }) { (error) in
              
                print(error)
            }
        }

    }
    
    func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logiutError {
            
            print(logiutError)
        }
        
        let loginController = LoginController()
        
        present(loginController, animated: true, completion: nil)
     
    }

}

