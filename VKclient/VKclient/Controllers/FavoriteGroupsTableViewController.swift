//
//  FavoriteGroupsController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class FavoriteGroupsTableViewController: UITableViewController {
    let getDataService: GroupsDataServiceProtocol = GroupsDataService(parser: GroupsSwiftyJSONParser())
    
    var favoriteGroups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiParameters: [String : Any] = [
            
            "extended" : 1
            ]

        getDataService.loadData(additionalParameters: apiParameters) { (groups) in
            
            self.favoriteGroups = groups
            
            self.tableView.reloadData()
        }
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
        
        cell.favoriteGroupNameLabel.text = favoriteGroups[indexPath.row].name
        cell.favoriteGroupAvatarImage.image = getImageByURL(imageUrl: favoriteGroups[indexPath.row].avatar)
        
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
