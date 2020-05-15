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
    
    private let dataService: DataServiceProtocol = DataService()
    private let realmService: RealmServiceProtocol = RealmService()
    private lazy var imageCache = ImageCache(table: self.tableView)
    
    private let queue: DispatchQueue = DispatchQueue(label: "GroupsTVC_queue", qos: .userInteractive)
    
    private var tokens: [NotificationToken] = []
    
    private var groups: [Results<Group>] = []


    private let requestUrl = "https://api.vk.com/method/groups.get"
    private let parameters: Parameters = [
        "access_token" : SessionData.shared.token,
        "v" : "5.103",
        "extended" : 1
    ]
    
    private let opq = OperationQueue()
    
    func prepareGroups() {
        
        do {
            tokens.removeAll()
            let realm = try Realm()
            realm.refresh()
            let groupsAlphabet = Array( Set( realm.objects(Group.self).compactMap{ $0.name.first?.uppercased() } ) ).sorted()
            groups = groupsAlphabet.map { realm.objects(Group.self).filter("name BEGINSWITH[c] %@", $0) }
            groups.enumerated().forEach{ observeChanges(section: $0.offset, results: $0.element) }
            tableView.reloadData()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func observeChanges(section: Int, results: Results<Group>) {
        tokens.append(
            results.observe { (changes) in
                switch changes {
                case .initial:
                    self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                    
                case .update(_, let deletions, let insertions, let modifications):
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: deletions.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                    self.tableView.insertRows(at: insertions.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                    self.tableView.reloadRows(at: modifications.map{ IndexPath(row: $0, section: section) }, with: .automatic)
                    self.tableView.endUpdates()

                
                case .error(let error):
                    print(error.localizedDescription)
                
                }
            }
        )
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(updateGroups), for: .valueChanged)
        
        opq.qualityOfService = .userInteractive
        
        let request = Alamofire.request(requestUrl, parameters: parameters)
        
        let getDataOperation = GetDataOperation(request: request)
        opq.addOperation(getDataOperation)
        
        let parseGroups = ParseGroupsOperation()
        parseGroups.addDependency(getDataOperation)
        opq.addOperation(parseGroups)
        
        parseGroups.completionBlock = {
            OperationQueue.main.addOperation {
                self.prepareGroups()
            }
        }
        
        //регистрируем xib для кастомного отображения header ячеек
        tableView.register(UINib(nibName: "CustomCellHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellHeaderView")
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groups[section].first?.name.first?.uppercased()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // настраиваем отображение кастомного title для header ячеек
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellHeaderView")
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell else {
            preconditionFailure("Can't create GroupCell")
        }
        
        let group = groups[indexPath.section][indexPath.row]
        let imageURL = group.avatar
        
        cell.favoriteGroupNameLabel.text = group.name
        cell.favoriteGroupAvatarImage.image = imageCache.image(indexPath: indexPath, url: imageURL)
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let group = groups[indexPath.section][indexPath.row]
        
        // долбавление возможности удаления ячейки
        
        if editingStyle == .delete {
            
            do {
                try realmService.deleteObject(object: group)
            } catch {
                print(error.localizedDescription)
            }
            
            prepareGroups()
        }
    }
    
    @objc func updateGroups() {
        
        dataService.loadGroups() {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.prepareGroups()
                self.refreshControl?.endRefreshing()
            }
            
        }
        
    }

}
