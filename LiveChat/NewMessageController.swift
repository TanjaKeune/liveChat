//
//  NewMessageController.swift
//  LiveChat
//
//  Created by Tanja Keune on 9/10/17.
//  Copyright © 2017 SUGAPP. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let cellId = "cellId"
    
    var users = [Users]()
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        fetchUser()
    }

    func fetchUser() {
        
        Database.database().reference().child("users").observe(DataEventType.childAdded, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = Users()
                
//                if you use this setter your app will crash if your class properties don't match up with the firebase dictionary keys
                
//                user.setValuesForKeys(dictionary)
                
//                safer way
                
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                self.users.append(user)
//                print(user.name!, user.email!)
                
//                this will crash because of background thread, so lets use dispatch_async to fix
//                self.tableView.reloadData()
           
                DispatchQueue.main.async(execute: {
                    
                    self.tableView.reloadData()
                })
            }
        }) { (error) in
            print(error)
        }
        
    }
    
    func handleCancel() {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let use a hack for now, we actually need to dequeue our cells for meory efficiency
        
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }
}


class UserCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
