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
    private let queue: DispatchQueue = DispatchQueue(label: "NewsTVC_queue", qos: .userInteractive)
    
    private var sections: [Results<News>] = []
    private var tokens: [NotificationToken] = []
    
    private var likeBox = Like()
    
    func prepareSections() {
        
        do {
            tokens.removeAll()
            let realm = try Realm()
            realm.refresh()
            sections = Array( arrayLiteral: realm.objects(News.self).sorted(byKeyPath: "date", ascending: false) )
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.prepareSections()
            }
            
        }
        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let news = sections[indexPath.section][indexPath.row]
        
        let cell = getCellPrototype(news: news, indexPath: indexPath)
        
        
        if let source = self.realmService.getNewsSourceById(id: news.sourceId) {
            
            cell.sourceName.text = source.name
            
            let imageURL = source.avatar
            
            queue.async {
                if let image = self.dataService.getImageByURL(imageURL: imageURL) {
                    
                    DispatchQueue.main.async {
                        cell.sourceImage.image = image
                    }
                }
            }
        }
        
        
        // Date
        cell.date.text = dateFormatter(inputDate: news.date)
        
        // Actions
        cell.viewsImage.image = UIImage(imageLiteralResourceName: "viewsImage")
        cell.viewsCounter.text = "\(news.views)"
        cell.commentsButton.image = UIImage(imageLiteralResourceName: "commentsImage")
        cell.commentsCounter.text = "\(news.comments)"
        cell.repostImage.image = UIImage(imageLiteralResourceName: "repostImage")
        cell.repostCounter.text = "\(news.reposts)"
        cell.likeImage.image = likeBox.image
        cell.likeCounter.text = "\(news.likes)"
        cell.shareButton.image = UIImage(imageLiteralResourceName: "shareImage")
        
        return cell
    }
    
    
    @objc func updateNews() {
        
        dataService.loadNews {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.prepareSections()
                self.refreshControl?.endRefreshing()
            }
            
        }
        
    }
    
    
    func getCellPrototype(news: News, indexPath: IndexPath) -> NewsCell {
        
        var cell: NewsCell = .init()
        
        let imageURL = news.imageURL
        
        if news.imageURL == "" {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellTextOnly", for: indexPath) as! NewsCell
            
            cell.newsText.text = news.text
            
        } else if news.text == "" {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellImageOnly", for: indexPath) as! NewsCell
            
            queue.async {
                if let image = self.dataService.getImageByURL(imageURL: imageURL) {
                    
                    DispatchQueue.main.async {
                        cell.newsImage.image = image
                    }
                }
            }
            
        } else {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
            
            cell.newsText.text = news.text
            
            queue.async {
                if let image = self.dataService.getImageByURL(imageURL: imageURL) {
                    
                    DispatchQueue.main.async {
                        cell.newsImage.image = image
                    }
                }
            }
            
        }
        
        return cell
    }
    
    
    private func dateFormatter(inputDate: Double) -> String {
        let dateFormatter = DateFormatter()
        let date = NSDate(timeIntervalSince1970: inputDate)
        dateFormatter.dateFormat = "dd.MM.yyyy" // тут может быть любой нужный вам формат, гуглите как писать форматы
        let convertedDate = dateFormatter.string(from: date as Date)
        return convertedDate
    }

}
