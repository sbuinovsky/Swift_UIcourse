//
//  FriendsController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UITableViewController {
    
    private let dataService: DataServiceProtocol = DataService()
    private let realmService: RealmServiceProtocol = RealmService()
    
    private var sections: [Results<User>] = []
    private var tokens: [NotificationToken] = []
    
    private let searchController: UISearchController = .init()
    
    func prepareSections() {
        
        do {
            tokens.removeAll()
            let realm = try Realm()
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
        
        tableView.tableHeaderView = searchController.searchBar
        
        dataService.loadUsers()
        
        prepareSections()
        
        //регистрируем xib для кастомного отображения header ячеек
        tableView.register(UINib(nibName: "FriendsTableViewCellHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellHeaderView")
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].first?.name.first?.uppercased()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // настраиваем отображение кастомного title для header ячеек
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellHeaderView")
    }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // делаем массив плоским
        let sectionsJoined = sections.joined()
        
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
        
        let friend = sections[indexPath.section][indexPath.row]
        
        let url = friend.avatar
        
        //заполнение ячейки
        cell.friendNameLabel.text = friend.name
        
        DispatchQueue.global().async {
            if let image = self.dataService.getImageByURL(imageURL: url) {
                
                DispatchQueue.main.async {
                   cell.friendAvatarImage.image = image
                }
            }
        }

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let friend = sections[indexPath.section][indexPath.row]
        
        // долбавление возможности удаления ячейки
        
        if editingStyle == .delete {
            
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(friend)
                try realm.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "friendProfileSegue" {
            guard let friendProfileController = segue.destination as? FriendProfileCollectionViewController else { return }
            
            if let indexPath = tableView.indexPathForSelectedRow {
                friendProfileController.friend = sections[indexPath.section][indexPath.row]
            }
            
            
        }
    }

}


extension FriendsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let text = searchController.searchBar.text {
            do {
                tokens.removeAll()
                let realm = try Realm()
                let friendsAlphabet = Array( Set( realm.objects(User.self).filter("name contains %@", text).compactMap{ $0.name.first?.uppercased() } ) ).sorted()
                sections = friendsAlphabet.map { realm.objects(User.self).filter("name BEGINSWITH[c] %@", $0) }
                sections.enumerated().forEach{ observeChanges(section: $0.offset, results: $0.element) }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
        tableView.reloadData()
    }
    
}
