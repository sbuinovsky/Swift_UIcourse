//
//  NewsTableViewController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 17.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift

class NewsTVC: UITableViewController {
    
    private let dataService: DataServiceProtocol = DataService()
    private let realmService: RealmServiceProtocol = RealmService()
    
    private var sections: [Results<News>] = []
    private var tokens: [NotificationToken] = []

    private var likeBox = Like()
    
    private var group: Group?
    
    func prepareSections() {
        
        do {
            tokens.removeAll()
            let realm = try Realm()
            sections = Array( arrayLiteral: realm.objects(News.self) )
            sections.enumerated().forEach{ observeChanges(section: $0.offset, results: $0.element) }
            tableView.reloadData()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func observeChanges(section: Int, results: Results<News>) {
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
        refreshControl?.addTarget(self, action: #selector(updateNews), for: .valueChanged)

        dataService.loadNews {
            self.tableView.reloadData()
            self.prepareSections()
        }
        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            preconditionFailure("Can't deque NewsCell")
            
        }
        
        let news = sections[indexPath.section][indexPath.row]
        
        //обработка даты в String формат
        let dateFormatter = DateFormatter()
        let date = NSDate(timeIntervalSince1970: news.date)
        dateFormatter.dateFormat = "dd.MM.yyyy" // тут может быть любой нужный вам формат, гуглите как писать форматы
        let convertedDate = dateFormatter.string(from: date as Date)
        
        dataService.loadGroups {
            self.group = self.realmService.getGroupById(id: news.sourceId)
        }
        
        let groupImage = self.dataService.getImageByURL(imageURL: self.group?.avatar ?? "")
        
        cell.groupImage.image = groupImage ?? nil
        cell.groupName.text = group?.name ?? ""
        cell.date.text = convertedDate
        cell.textField.text = news.text
        cell.likeImage.image = likeBox.image
        cell.likeCounter.text = "\(news.likes)"
        cell.shareButton.image = UIImage(imageLiteralResourceName: "shareImage")
        cell.commentsButton.image = UIImage(imageLiteralResourceName: "commentsImage")
        cell.viewsImage.image = UIImage(imageLiteralResourceName: "viewsImage")
        cell.viewsCounter.text = "\(news.views)"
        cell.newsImage.image = dataService.getImageByURL(imageURL: news.imageURL)
        
        return cell
    }
    
    @objc func updateNews() {
        
        dataService.loadGroups() {
            self.tableView.reloadData()
            self.prepareSections()
            self.refreshControl?.endRefreshing()
        }

    }

}


//if let indexPath = tableView.indexPathForSelectedRow {
//    friendProfileController.friend = activeSections[indexPath.section][indexPath.row]
//}
