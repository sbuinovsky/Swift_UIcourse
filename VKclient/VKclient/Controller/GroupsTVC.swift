//
//  FavoriteGroupsController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire


class GroupsTVC: UITableViewController {
    
    private let viewModelFactory = GroupsViewModelFactory()
    private var viewModels: [GroupViewModel] = []
    
    private let dataService: DataServiceProtocol = DataService()
    private let realmService: RealmServiceProtocol = RealmService()
    private lazy var imageCache = ImageCache(table: self.tableView)
    
    private let queue: DispatchQueue = DispatchQueue(label: "GroupsTVC_queue", qos: .userInteractive)
    
    private var tokens: [NotificationToken] = []
    
    private var groups: [Group] = []


    private let requestUrl = "https://api.vk.com/method/groups.get"
    private let parameters: Parameters = [
        "access_token" : SessionData.shared.token,
        "v" : "5.103",
        "extended" : 1
    ]
    
    private let opq = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(updateGroups), for: .valueChanged)
        
        dataService.loadGroups {
            self.groups = self.realmService.getGroups()
            self.viewModels = self.viewModelFactory.constructGroupsViewModel(groups: self.groups)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        //регистрируем xib для кастомного отображения header ячеек
        tableView.register(UINib(nibName: "CustomCellHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellHeaderView")
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell else {
            preconditionFailure("Can't create GroupCell")
        }
        
        let viewModel = viewModels[indexPath.row]
        
        cell.favoriteGroupNameLabel.text = viewModel.name
        cell.favoriteGroupAvatarImage.image = viewModel.avatar
        
        
        return cell
    }
    
    
    @objc func updateGroups() {
        
        dataService.loadGroups {
            self.groups = self.realmService.getGroups()
            self.viewModels = self.viewModelFactory.constructGroupsViewModel(groups: self.groups)
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
            
        }
        
    }

}
