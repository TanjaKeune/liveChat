//
//  ViewController.swift
//  LiveChat
//
//  Created by Tanja Keune on 9/4/17.
//  Copyright © 2017 SUGAPP. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
  
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
    }
    
    func handleLogout() {
        
        let loginController = LoginController()
        
        present(loginController, animated: true, completion: nil)
     
    }

}

