//
//  FavoriteGroupsController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteGroupsTableViewController: UITableViewController {
    let dataService: DataServiceProtocol = DataService()
    let realmService: RealmService = .init()
    
    var favoriteGroups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiParameters: [String : Any] = [
            "extended" : 1
            ]

        dataService.loadGroups(additionalParameters: apiParameters) {
            self.favoriteGroups = self.realmService.getGroups()
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
        
        let url = favoriteGroups[indexPath.row].avatar
        
        cell.favoriteGroupNameLabel.text = favoriteGroups[indexPath.row].name
        
        DispatchQueue.global().async {
            if let image = self.dataService.getImageByURL(imageURL: url) {
                
                DispatchQueue.main.async {
                    cell.favoriteGroupAvatarImage.image = image
                }
            }
        }
        
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

}
