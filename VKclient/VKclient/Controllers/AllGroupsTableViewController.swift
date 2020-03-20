//
//  AllGroupsController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class AllGroupsTableViewController: UITableViewController {
    
    var allGroups: [Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Начало получения данных
//                
//        let apiMethod = "groups.search"
//        
//        let parameters: [String : String] = [
//            "q" : "swift",
//            "extended" : "1",
//        ]
//        
//        
//        let getFriends: GetDataService = .init()
//        getFriends.loadFriendsData(method: apiMethod, parameters: parameters)
//        
//        // Конец получения данных

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell else {
            preconditionFailure("Can't create GroupCell")
        }
        
        let group = allGroups[indexPath.row]
//        cell.groupNameLabel.text = group.name
//        cell.groupAvatarImage.image = group.avatar
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            allGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
