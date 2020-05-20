
//
//  FriendsController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift
import PromiseKit

class FriendsTVC: UITableViewController {
    
    private let dataService: DataServiceProtocol = DataService()
    private let realmService: RealmServiceProtocol = RealmService()
    private lazy var imageCache = ImageCache(table: self.tableView)
    
    private var sections: [Results<User>] = []
    private var tokens: [NotificationToken] = []
    private var filteredSections: [Results<User>] = []
    private var activeSections: [Results<User>] {
        searchController.isActive ? filteredSections : sections
    }
    
    private let searchController: UISearchController = .init()
    
    func prepareSections() {
        
        do {
            tokens.removeAll()
            let realm = try Realm()
            realm.refresh()
            let friendsAlphabet = Array( Set( realm.objects(User.self).compactMap{ $0.name.first?.uppercased() } ) ).sorted()
            sections = friendsAlphabet.map { realm.objects(User.self).filter("name BEGINSWITH[c] %@", $0) }
            sections.enumerated().forEach{ observeChanges(section: $0.offset, results: $0.element) }
            tableView.reloadData()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func observeChanges(section: Int, results: Results<User>) {
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
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(updateFriends), for: .valueChanged)
        
        dataService.loadFriends()
            .done(on: DispatchQueue.main) { (user) in
                self.prepareSections()
        }
        
        tableView.backgroundColor = UIColor(named: "main_background")
        
        //регистрируем xib для кастомного отображения header ячеек
        tableView.register(UINib(nibName: "CustomCellHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellHeaderView")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return activeSections.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return activeSections[section].first?.name.first?.uppercased()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeSections[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // настраиваем отображение кастомного title для header ячеек
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellHeaderView")
    }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // делаем массив плоским
        let sectionsJoined = activeSections.joined()
        
        // трансформируем в массив первых букв
        let letterArray = sectionsJoined.compactMap{ $0.name.first?.uppercased() }
        
        // убираем неуникальные значения
        let set = Set(letterArray)
        
        return Array(set).sorted()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            preconditionFailure("Can't deque FriendCell")
        }
        
        let friend = activeSections[indexPath.section][indexPath.row]
        
        //заполнение ячейки
        cell.friendNameLabel.text = friend.name
        
        let imageURL = friend.avatar
        
        cell.friendAvatarImage.image = imageCache.image(indexPath: indexPath, url: imageURL)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let friend = activeSections[indexPath.section][indexPath.row]
        
        // долбавление возможности удаления ячейки
        
        if editingStyle == .delete {
            
            do {
                try realmService.deleteObject(object: friend)
            } catch {
                print(error.localizedDescription)
            }
            
            prepareSections()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "UserProfileSeague" {
            guard let userProfileTVC = segue.destination as? UserProfileTVC else { return }
            
            if let indexPath = tableView.indexPathForSelectedRow {
                userProfileTVC.user = activeSections[indexPath.section][indexPath.row]
            }
            
        }
    }
    
    @objc func updateFriends() {
        
        dataService.loadFriends()
            .done(on: DispatchQueue.main) { (user) in
                self.prepareSections()
                self.refreshControl?.endRefreshing()
        }
        
    }

}


extension FriendsTVC: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

        if let text = searchController.searchBar.text {
            filteredSections = sections.map { $0.filter("name BEGINSWITH[c] %@", text) }
            tableView.reloadData()
        }

    }
    

}
