//
//  FriendsController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class FriendsController: UITableViewController {
    
    var friends = [
        User(name: "User 1", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "User 2", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "User 3", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "User 4", avatar: UIImage(imageLiteralResourceName: "friendImage")),
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            preconditionFailure("Can't deque FriendCell")
        }
        
        let friend = friends[indexPath.row]
        
        cell.FriendName.text = friend.name
        cell.FriendAvatarImage.image = friend.avatar
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


}
