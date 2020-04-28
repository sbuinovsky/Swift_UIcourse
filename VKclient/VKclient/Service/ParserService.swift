//
//  ParserService.swift
//  VKclient
//
//  Created by Станислав Буйновский on 12.04.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol ParserServiceProtocol {
    func usersParser(data: Data) -> [User]
    func groupsParser(data: Data) -> [Group]
    func photosParser(data: Data) -> [Photo]
    func newsParser(data: Data) -> [News]
    func sourceGroupsParser(data: Data) -> [NewsSource]
    func sourceUsersParser(data: Data) -> [NewsSource]
}

class ParserService: ParserServiceProtocol {
    
    private let firebaseService: FirebaseServiceProtocol = FirebaseService()
    
    
    func usersParser(data: Data) -> [User] {

        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> User in
                
                let user = User()
                user.id = item["id"].intValue
                user.name = item["first_name"].stringValue + " " + item["last_name"].stringValue
                user.avatar = item["photo_200_orig"].stringValue
                
                firebaseService.updateFriends(object: user)
                
                return user
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    
    func groupsParser(data: Data) -> [Group] {

        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> Group in
            
                let group = Group()
                
                group.id = item["id"].intValue
                group.name = item["name"].stringValue
                group.avatar = item["photo_200"].stringValue
                
                firebaseService.updateGroups(object: group)
                
                return group
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    
    func photosParser(data: Data) -> [Photo] {
    
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> Photo in
                
                let photo = Photo()
                photo.id = item["id"].intValue
                photo.ownerId = item["owner_id"].intValue
                
                let sizeValues = item["sizes"].arrayValue
                if let last = sizeValues.last {
                    photo.imageUrl = last["url"].stringValue
                }
                
                return photo
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    
    func newsParser(data: Data) -> [News] {

        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> News in
                
                let news = News()
                
                news.postId = item["post_id"].intValue
                news.sourceId = item["source_id"].intValue
                news.date = item["date"].doubleValue
                news.text = item["text"].stringValue
                
                let photoSet = item["attachments"].arrayValue.first?["photo"]["sizes"].arrayValue
                if let first = photoSet?.first (where: { $0["type"].stringValue == "z" } ) {
                    news.imageURL = first["url"].stringValue
                }
                
                
                news.views = item["views"]["count"].intValue
                news.likes = item["likes"]["count"].intValue
                news.comments = item["comments"]["count"].intValue
                news.reposts = item["reposts"]["count"].intValue
                
                return news
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func sourceGroupsParser(data: Data) -> [NewsSource] {

        do {
            let json = try JSON(data: data)
            let array = json["response"]["groups"].arrayValue
            
            let result = array.map { item -> NewsSource in
            
                let sourceGroup = NewsSource()
                
                sourceGroup.id = item["id"].intValue
                sourceGroup.name = item["name"].stringValue
                sourceGroup.avatar = item["photo_200"].stringValue
                
                firebaseService.updateNewsSource(object: sourceGroup)
                
                return sourceGroup
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func sourceUsersParser(data: Data) -> [NewsSource] {

        do {
            let json = try JSON(data: data)
            let array = json["response"]["profiles"].arrayValue
            
            let result = array.map { item -> NewsSource in
                
                let sourceUser = NewsSource()
                sourceUser.id = item["id"].intValue
                sourceUser.name = item["first_name"].stringValue + " " + item["last_name"].stringValue
                sourceUser.avatar = item["photo_100"].stringValue
                
                firebaseService.updateNewsSource(object: sourceUser)
                
                return sourceUser
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

}
