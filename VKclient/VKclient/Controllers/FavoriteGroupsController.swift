//
//  FavoriteGroupsController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class FavoriteGroupsController: UITableViewController {
    @IBOutlet weak var addGroup: UIBarButtonItem!
    
    var favoriteGroups = [
        Group(name: "Group 1", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 2", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 3", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        Group(name: "Group 4", avatar: UIImage(imageLiteralResourceName: "groupImage")),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.FavoriteGroupName.text = favoriteGroup.name
        cell.FavoriteGroupAvatarImage.image = favoriteGroup.avatar

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
    
    @IBAction func addGroup(_ sender: Any) {
        favoriteGroups.append(Group(name: "Added Group", avatar: .add))
        tableView.reloadData()
    }
   


}
