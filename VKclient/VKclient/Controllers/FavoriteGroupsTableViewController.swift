//
//  FavoriteGroupsController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class FavoriteGroupsTableViewController: UITableViewController {
    
    var favoriteGroups = [
        Group(name: "Group 1", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 2", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 3", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 4", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 5", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 6", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 7", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 8", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 9", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 10", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 11", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 12", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 13", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 14", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 15", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 16", avatar: UIImage(imageLiteralResourceName: "groupImage")),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Начало получения данных
        
        let apiKey = SessionData.shared.token
        
        let apiMethod = "groups.get"
        
        let parameters: [String : String] = [
            "extended" : "1",
            "access_token" : apiKey,
            "v" : "5.103"
        ]
        
        
        let getFriends: GetDataService = .init()
        getFriends.loadFriendsData(method: apiMethod, parametersDict: parameters)
        
        // Конец получения данных
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell else {
            preconditionFailure("Can't create GroupCell")
        }
        
        let favoriteGroup = favoriteGroups[indexPath.row]
        cell.favoriteGroupNameLabel.text = favoriteGroup.name
        cell.favoriteGroupAvatarImage.image = favoriteGroup.avatar
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoriteGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            guard let allGroupsController = segue.source as? AllGroupsTableViewController else { return }
            
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                let group = allGroupsController.allGroups[indexPath.row]
                
                if !favoriteGroups.contains(group) {
                    favoriteGroups.append(group)
                }
                
                tableView.reloadData()
            }
        }
    }


}
