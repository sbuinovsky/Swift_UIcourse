//
//  FriendsController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    let getDataService: UsersDataServiceProtocol = UsersDataService(parser: SwiftyJSONParser())
    
    var friends: [User] = []
    
    // создаем массив для алфавитного указателя
    var friendsNamesAlphabet = [String]()
    
    //словарь с именами пользователей
    var friendsNamesArray = [[String]]()
    
    //словарь с именами пользователей
    var defaultfriendsNamesArray = [[String]]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getDataService.loadUsersData() { (users) in
            self.friends = users
            self.fillFriendsNamesAlphabet()
            self.fillFriendsNamesArray()
            self.defaultfriendsNamesArray = self.friendsNamesArray
            self.tableView.reloadData()
        }
        
        //регистрируем xib для кастомного отображения header ячеек
        tableView.register(UINib(nibName: "FriendsTableViewCellHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellHeaderView")
    }
    
    func fillFriendsNamesAlphabet() {
        for index in 0..<friends.count {
            guard let firstCharacter = friends[index].name.first else { return } //забираем первые символы
                friendsNamesAlphabet.append(String(firstCharacter))
            }
        
        friendsNamesAlphabet = Array(Set(friendsNamesAlphabet)).sorted()
    }
    
    func fillFriendsNamesArray() {
        for section in 0..<friendsNamesAlphabet.count {
            var tempString = [String]() //временный массив накопления имен
            
            for index in 0..<friends.count {
                if String(friends[index].name.first!) == friendsNamesAlphabet[section] && friends[index].name != " DELETED" {
                    tempString.append(String(friends[index].name))
                }
            }
            
            friendsNamesArray.append(tempString)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsNamesArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //формируем title для header секций
        guard let headerTitle = friendsNamesArray[section].first?.first else { return nil }
        return "\(headerTitle)"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsNamesArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // настраиваем отображение кастомного title для header ячеек
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellHeaderView")
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // вывод боковой полоски алфавитного указателя справа экрана
        return friendsNamesAlphabet
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            preconditionFailure("Can't deque FriendCell")
        }
        
        let friendName = friendsNamesArray[indexPath.section][indexPath.row]
        var friendImage: UIImage = .remove //заглушка по умолчанию
        
        //ищем в исходных данных аватар соответствующий имени пользователя
        for index in 0..<friends.count {
            if friendName == friends[index].name {
                let urlString = friends[index].avatar
                let url = NSURL(string: urlString)! as URL
                if let imageData: NSData = NSData(contentsOf: url) {
                    friendImage = UIImage(data: imageData as Data) ?? friendImage
                }
            }
        }

        //заполнение ячейки
        cell.friendNameLabel.text = friendName
        cell.friendAvatarImage.image = friendImage
        
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
            
            friendProfileController.friendName = cell.friendNameLabel.text
            friendProfileController.friendAvatar = cell.friendAvatarImage.image
        }
    }

}

extension FriendsTableViewController: UISearchBarDelegate {
    // реализация работы поисковой строки
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        for index in 0..<friendsNamesArray.count {
            friendsNamesArray[index] = friendsNamesArray[index].filter { $0.range(of: searchText, options: .caseInsensitive) != nil }
        }
        if searchText == "" {
            friendsNamesArray = defaultfriendsNamesArray
        }
        tableView.reloadData()
    }
}
