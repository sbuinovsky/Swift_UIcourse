//
//  FriendsController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class FriendsController: UITableViewController {
    
    let friends = [
        "Petrov Petr",
        "Ivanov Ivan",
        "Dmitriev Dmytry",
        "Vasilev Vasily"
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
        
        let friendName = friends[indexPath.row]
        cell.friendNameLabel.text = friendName
        
        return cell
    }


}
