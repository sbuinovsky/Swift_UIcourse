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
    private lazy var imageCache = ImageCache(table: self.tableView)
    
    private let queue: DispatchQueue = DispatchQueue(label: "NewsTVC_queue", qos: .userInteractive)
    
    private var sections: Results<News>?
    private var token: NotificationToken?
    
    weak var delegate: NewsTopCellDelegate?
    
    private var likeBox = Like()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    private var cachedDates = [IndexPath: String]()
    
    private var fullTextCells = Set<IndexPath>()
    
    private var startFrom: String = ""
    private var loading: Bool = false
    
    
    
    func prepareSections() {
        
        do {
            let realm = try Realm()
            realm.refresh()
            sections = realm.objects(News.self).sorted(byKeyPath: "date", ascending: false)
            observeChanges()
            tableView.reloadData()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func observeChanges() {
        token = sections?.observe { (changes) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
                
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.deleteSections(.init(deletions), with: .automatic)
                self.tableView.insertSections(.init(insertions), with: .automatic)
                self.tableView.reloadSections(.init(modifications), with: .automatic)
                self.tableView.endUpdates()
                
            case .error(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.prefetchDataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(updateNews), for: .valueChanged)
        
        loading = true
        dataService.loadNews(startFrom: "") { [weak self] startFrom in
            self?.startFrom = startFrom
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.prepareSections()
                self?.loading = false
            }
            
        }
        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let news = sections?[indexPath.section] else { return UITableView.automaticDimension}
        
        if indexPath.row == 1, news.hasImage {
            return tableView.bounds.width * news.aspectRatio
        }
        else {
            return UITableView.automaticDimension
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = sections?[section] else { return 0 }

        if section.imageURL == "" && section.text == "" {
            return 0
        }
        
        if section.hasImage {
            return 3
        }
        else {
            return 2
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let news = sections![indexPath.section]
        
        let cell = getCellPrototype(news: news, indexPath: indexPath)
        
        return cell
    }
    
    
    @objc func updateNews() {
        loading = true
        dataService.loadNews(startFrom: "") { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.prepareSections()
                self?.refreshControl?.endRefreshing()
                self?.loading = false
            }
            
        }
        
    }
    
    
    func getCellPrototype(news: News, indexPath: IndexPath) -> UITableViewCell {
        
        let imageURL = news.imageURL
        
        var activeText: String {
            fullTextCells.contains(indexPath) ? news.text : news.shortText
        }
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTopCell", for: indexPath) as! NewsTopCell
            
            cell.indexPath = indexPath
            
            cell.delegate = self
            
            if let source = self.realmService.getNewsSourceById(id: news.sourceId) {
                
                cell.sourceName.text = source.name
                
                let imageURL = source.avatar
                
                cell.sourceImage.image = imageCache.image(indexPath: indexPath, url: imageURL)
                
            }
            
            cell.date.text = dateFormat(inputDate: news.date)
            
            if fullTextCells.contains(indexPath) {
                cell.showMoreButton.setTitle("Show less", for: .normal)
            } else {
                cell.showMoreButton.setTitle("Show more", for: .normal)
            }
            
            cell.newsText.text = activeText
            cell.newsTextHeight.constant = cell.getRowHeightFromText(text: activeText)
            
            return cell
            
        } else if indexPath.row == 2 || !news.hasImage {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsBottomCell", for: indexPath) as! NewsBottomCell
            
            cell.viewsImage.image = UIImage(imageLiteralResourceName: "viewsImage")
            cell.viewsCounter.text = "\(news.views)"
            cell.commentsImage.image = UIImage(imageLiteralResourceName: "commentsImage")
            cell.commentsCounter.text = "\(news.comments)"
            cell.repostImage.image = UIImage(imageLiteralResourceName: "repostImage")
            cell.repostCounter.text = "\(news.reposts)"
            cell.likeImage.image = likeBox.image
            cell.likeCounter.text = "\(news.likes)"
            cell.shareButton.image = UIImage(imageLiteralResourceName: "shareImage")
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
            
            
            cell.setImage( image: imageCache.image(indexPath: indexPath, url: imageURL) )
            
            return cell
        }
        
    }
    
    
    private func dateFormat(inputDate: Double) -> String {
        let date = Date(timeIntervalSince1970: inputDate)
        let convertedDate = dateFormatter.string(from: date as Date)
        return convertedDate
    }
    
}

extension NewsTVC: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard !loading,
            let maxSection = indexPaths.map(\.section).max(),
            let sections = sections,
            maxSection > sections.count - 8 else { return }
        
        loading = true
        dataService.loadNews(startFrom: startFrom) { [weak self] startFrom in
            self?.startFrom = startFrom
            self?.loading = false
        }
    }
    
}

extension NewsTVC: NewsTopCellDelegate {
    func showMoreTapped(indexPath: IndexPath) {
        
//        let cell = tableView.cellForRow(at: indexPath) as! NewsTopCell
        
        if fullTextCells.contains(indexPath) {
            fullTextCells.remove(indexPath)
            
        }
        else {
            fullTextCells.insert(indexPath)

        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }

}
