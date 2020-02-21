//
//  FriendsController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    var friends : [User] = [
        User(name: "Ivanov Ivan", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Ivanov Andrei", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Petrov Petr", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Sidorov Sidr", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Vinogradov Vasily", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Eroshkin Egor", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Yardov Nikolay", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Zagorian Armen", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Tupichkin Andrei", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Karasev Ivan", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Prevolgin Petr", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Arutunov Anton", avatar: UIImage(imageLiteralResourceName: "groupImage")),
        User(name: "Krestov Kirill", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Ivanov Vasily", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Petrov Petr", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Sidorov Petr", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Vinogradov Ivan", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Eroshkin Andrei", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Yardov Nikolay", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Zagorian Artur", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Tupichkin Andrei", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Karasev Ivan", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Prevolgin Petr", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Arutunov Vladimir", avatar: UIImage(imageLiteralResourceName: "friendImage")),
        User(name: "Krestov Oleg", avatar: UIImage(imageLiteralResourceName: "friendImage"))
    ]
    
    // создаем массив для алфавитного указателя
    var friendsNamesAlphabet = [String]()
    
    //словарь с именами пользователей
    var friendsNamesArray = [[String]]()
    
    //словарь с именами пользователей
    var defaultfriendsNamesArray = [[String]]()
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FriendsTableViewCellHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellHeaderView")
        
        for index in 0..<friends.count {
            guard let firstCharacter = friends[index].name.first else { return } //забираем первые символы
                friendsNamesAlphabet.append(String(firstCharacter))
            }
        
        friendsNamesAlphabet = Array(Set(friendsNamesAlphabet)).sorted() //убираем дубли и сортируем по алфавиту
        
        for section in 0..<friendsNamesAlphabet.count {
            var tempString = [String]() //временный массив накопления имен
            
            for index in 0..<friends.count {
                if String(friends[index].name.first!) == friendsNamesAlphabet[section] {
                    tempString.append(String(friends[index].name))
                }
            }
            
            friendsNamesArray.append(tempString)
        }
        
        defaultfriendsNamesArray = friendsNamesArray
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsNamesArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let headerTitle = friendsNamesArray[section].first?.first else { return nil }
        return "\(headerTitle)"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsNamesArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellHeaderView")
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
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
                friendImage = friends[index].avatar
            }
        }
        
        //заполнение ячейки
        cell.friendNameLabel.text = friendName
        cell.friendAvatarImage.image = friendImage
        
        //скругление аватара пользователя
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: 30, y:30), radius: 20, startAngle: 0, endAngle: 360, clockwise: true)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        cell.friendAvatarImage.layer.mask = maskLayer
        
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
