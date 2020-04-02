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
    let dataService: DataServiceProtocol = DataService()
    let realmService: RealmService = .init()

    var friends: [User] = []
    
    // создаем массив для алфавитного указателя
    var friendsNamesAlphabet = [Character]()
    
    //словарь с именами пользователей
    var friendsNamesArray = [[String]]()
    
    //словарь с именами пользователей
    var defaultfriendsNamesArray = [User]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        let apiParameters: [String : Any] = [
            "user_ids" : "7359889",
            "fields" : "photo_200_orig",
            "order" : "name",
            ]

        dataService.loadUsers(additionalParameters: apiParameters) {
            self.friends = self.realmService.getUsers()
            self.friendsNamesAlphabet = self.fillFriendsNamesAlphabet(friendsArray: self.friends)
            self.defaultfriendsNamesArray = self.friends
            self.tableView.reloadData()
        }
        
        
        //регистрируем xib для кастомного отображения header ячеек
        tableView.register(UINib(nibName: "FriendsTableViewCellHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellHeaderView")
    }
    
    func fillFriendsNamesAlphabet(friendsArray: [User]) -> [Character] {
        var alphabetArray = [Character]()
        for index in 0..<friendsArray.count {
            
            let firstCharacter = friendsArray[index].name.first! //забираем первые символы
            alphabetArray.append(firstCharacter)
            
            }
        
        alphabetArray = Array(Set(alphabetArray)).sorted()
        
        return alphabetArray
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsNamesAlphabet.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //формируем title для header секций
        let headerTitle = friendsNamesAlphabet[section]
        return "\(headerTitle)"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friendsForSection = friends.filter { $0.name.first == friendsNamesAlphabet[section] }
        return friendsForSection.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // настраиваем отображение кастомного title для header ячеек
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellHeaderView")
    }
    
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        // вывод боковой полоски алфавитного указателя справа экрана
//        return friendsNamesAlphabet
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            preconditionFailure("Can't deque FriendCell")
        }
        
        let friendsForSection = friends.filter { $0.name.first == friendsNamesAlphabet[indexPath.section] }
        
        let friendName = friendsForSection[indexPath.row].name
        
        let url = friendsForSection[indexPath.row].avatar
        
        //заполнение ячейки
        cell.friendNameLabel.text = friendName
        
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
        // долбавление возможности удаления ячейки
        
        if editingStyle == .delete {
            // Delete the row from the data source
            friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // реализация передачи имени и аватара на view с профилем пользователя
        
        if segue.identifier == "friendProfileSegue" {
            guard let friendProfileController = segue.destination as? FriendProfileCollectionViewController,
                let cell = sender as? FriendCell
                else { return }
            
            friendProfileController.friends = friends
            friendProfileController.friendName = cell.friendNameLabel.text
            friendProfileController.friendAvatar = cell.friendAvatarImage.image
        }
    }

}

extension FriendsTableViewController: UISearchBarDelegate {
    
    // реализация работы поисковой строки
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {
            
            friends = friends.filter { $0.name.range(of: searchText, options: .caseInsensitive) != nil }
            friendsNamesAlphabet = fillFriendsNamesAlphabet(friendsArray: friends)
            
        } else {
            
            friends = defaultfriendsNamesArray
            friendsNamesAlphabet = fillFriendsNamesAlphabet(friendsArray: friends)
        }
        
        tableView.reloadData()
    }
}
