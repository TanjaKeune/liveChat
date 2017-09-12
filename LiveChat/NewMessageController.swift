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
                user.profileImageURL = dictionary["profileImageURL"] as? String
                self.users.append(user)
                
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
//        
        if let profileImageURL = user.profileImageURL {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageURL)
            
//            let url = URL(string: profileImageURL)
//            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                
//                if error != nil {
//                    print(error)
//                    return
//                }
//                DispatchQueue.main.async(execute: {
//                    
//                    cell.profileImageView.image = UIImage(data: data!)
//                })
//            }).resume()
        }
        return cell
    
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}


class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        
       let imageView = UIImageView()
        imageView.image = UIImage(named: "luck")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        
//        ios 9 constraint anchors
//        we need x, y, height, anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
