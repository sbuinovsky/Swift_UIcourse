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
        
        cell.friendNameLabel.text = friend.name
        cell.friendAvatarImage.image = friend.avatar
        
        //скругление аватара пользователя
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: 30, y:30), radius: 20, startAngle: 0, endAngle: 360, clockwise: true)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        cell.friendAvatarImage.layer.mask = maskLayer
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // долбавление возможности удаления ячейки
        
        if editingStyle == .delete {
            // Delete the row from the data source
            friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendProfileSegue" {
            guard let collectionViewController = segue.destination as? FriendProfileController,
                let cell = sender as? FriendCell
                else { return }
            
            collectionViewController.friendName = cell.friendNameLabel.text
        }
    }

}
