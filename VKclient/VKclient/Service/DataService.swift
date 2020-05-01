//
//  GetDataService.swift
//  VKclient
//
//  Created by Станислав Буйновский on 17.03.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

protocol DataServiceProtocol {
    func loadUsers(completion: @escaping () -> Void)
    func loadGroups(completion: @escaping () -> Void)
    func loadPhotos(targetId: Int, completion: @escaping () -> Void)
    func loadNews(completion: @escaping () -> Void)
    func getImageByURL(imageURL: String) -> UIImage?
}

class DataService: DataServiceProtocol {
    
    private let realmService: RealmService = .init()
    private let firebaseService: FirebaseServiceProtocol = FirebaseService()
    private let parser: ParserServiceProtocol = ParserService()

    private let baseUrl = "https://api.vk.com/method/"

    private var parameters: Parameters = [
        "access_token" : SessionData.shared.token,
        "v" : "5.103"
    ]

    private let queue = DispatchQueue(label: "dataService_queue", qos: .userInteractive, attributes: [.concurrent])

    private enum apiMethods: String {
        case friends = "friends.get"
        case groups = "groups.get"
        case photos = "photos.get"
        case groupsSearch = "groups.search"
        case groupsById = "groups.getById"
        case news = "newsfeed.get"
    }

    
    func loadUsers(completion: @escaping () -> Void) {
        
        let apiParameters: [String : Any] = [
            "user_ids" : "7359889",
            "fields" : "photo_100",
            "order" : "name",
        ]
        
        apiParameters.forEach { (k,v) in parameters[k] = v }
        
        let url = baseUrl + apiMethods.friends.rawValue
        
       
        AF.request(url, parameters: self.parameters).responseJSON(queue: queue) { (response) in
            if let error = response.error {
                print(error)
            } else {
                guard let data = response.data else { return }
                
                let users: [User] = self.parser.usersParser(data: data)
                
                
                self.realmService.saveObjects(objects: users)
                
                
                completion()
            }
            
        }
        
        
    }

    
    func loadGroups(completion: @escaping () -> Void) {
        
        let apiParameters: [String : Any] = [
            "extended" : 1
        ]
        
        apiParameters.forEach { (k,v) in parameters[k] = v }
        
        let url = baseUrl + apiMethods.groups.rawValue
        
        
        AF.request(url, parameters: self.parameters).responseJSON(queue: queue) { (response) in
            if let error = response.error {
                print(error)
            } else {
                guard let data = response.data else { return }
                
                let groups: [Group] = self.parser.groupsParser(data: data)
                
                
                self.realmService.saveObjects(objects: groups)
                
                
                completion()
            }
            
        }
        
    }

    
    func loadPhotos(targetId: Int, completion: @escaping () -> Void) {
        
        let apiParameters: [String : Any] = [
            "owner_id" :  targetId,
            "album_id" : "profile",
        ]
        
        apiParameters.forEach { (k,v) in parameters[k] = v }
        
        let url = baseUrl + apiMethods.photos.rawValue
        
        
        AF.request(url, parameters: self.parameters).responseJSON(queue: queue) { [completion] (response) in
            if let error = response.error {
                print(error)
            } else {
                guard let data = response.data else { return }
                
                let photos: [Photo] = self.parser.photosParser(data: data)
                
                DispatchQueue.main.async {
                    self.realmService.saveObjects(objects: photos)
                    
                }
                
                completion()
            }
            
        }
        
    }
    
    
    func loadNews(completion: @escaping () -> Void) {
        
        let apiParameters: [String : Any] = [
            "filters" : "post"
        ]
        
        apiParameters.forEach { (k,v) in parameters[k] = v }
        
        let url = baseUrl + apiMethods.news.rawValue
        
        
        AF.request(url, parameters: self.parameters).responseJSON(queue: queue) { (response) in
            if let error = response.error {
                print(error)
            } else {
                guard let data = response.data else { return }
                
                let news: [News] = self.parser.newsParser(data: data)
                let sourceGroups: [NewsSource] = self.parser.sourceGroupsParser(data: data)
                let sourceProfiles: [NewsSource] = self.parser.sourceUsersParser(data: data)
                
                
                self.realmService.saveObjects(objects: news)
                self.realmService.saveObjects(objects: sourceGroups)
                self.realmService.saveObjects(objects: sourceProfiles)
                
                
                completion()
                
            }
            
        }
        
    }

    
    func getImageByURL(imageURL: String) -> UIImage? {
        
        let urlString = imageURL
        guard let url = URL(string: urlString) else { return nil }
        
        if let imageData: Data = try? Data(contentsOf: url) {
            return UIImage(data: imageData)
        }
        
        return nil
    }
}
