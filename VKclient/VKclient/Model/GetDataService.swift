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

protocol UsersDataServiceProtocol {
    func loadUsersData(completion: @escaping ([User]) -> Void)
}

protocol UsersParser {
    func parse(data: Data) -> [User]
}

protocol GroupsDataServiceProtocol {
    func loadGroupsData(completion: @escaping ([Group]) -> Void)
}

protocol GroupsParser {
    func parse(data: Data) -> [Group]
}

protocol PhotosDataServiceProtocol {
    func loadPhotosData(completion: @escaping ([Photo]) -> Void)
}

protocol PhotosParser {
    func parse(data: Data) -> [Photo]
}

class APIparams {
    var url: String = ""
    var parameters: Parameters = [ : ]
}

class UsersDataService: UsersDataServiceProtocol {
    
    let baseUrl = "https://api.vk.com/method/"
    let parser: UsersParser
    
    init(parser: UsersParser) {
        self.parser = parser
    }
    
    let apiKey = SessionData.shared.token
    
    func loadUsersData(completion: @escaping ([User]) -> Void) {
        
        let parameters: Parameters = [
            "user_ids" : "7359889",
            "fields" : "photo_200_orig",
            "order" : "name",
            "access_token" : apiKey,
            "v" : "5.103"
        ]
        
        let method = "friends.get"
        
        let url = baseUrl + method
        
        AF.request(url, parameters: parameters).responseJSON { [completion] (response) in
            if let error = response.error {
                print(error)
            } else {
                guard let data = response.data else { return }
                
                let users: [User] = self.parser.parse(data: data)
                
                completion(users)
            }
            
        }
    }
}

class GroupsDataService: GroupsDataServiceProtocol {
    
    let baseUrl = "https://api.vk.com/method/"
    let parser: GroupsParser
    
    init(parser: GroupsParser) {
        self.parser = parser
    }
    
    let apiKey = SessionData.shared.token
    
    func loadGroupsData(completion: @escaping ([Group]) -> Void) {
        
        let parameters: Parameters = [
            "extended" : 1,
            "order" : "name",
            "access_token" : apiKey,
            "v" : "5.103"
        ]
        
        let method = "groups.get"
        
        let url = baseUrl + method
        
        AF.request(url, parameters: parameters).responseJSON { [completion] (response) in
            if let error = response.error {
                print(error)
            } else {
                guard let data = response.data else { return }
                
                let groups: [Group] = self.parser.parse(data: data)
                
                completion(groups)
            }
            
        }
    }
}

class PhotosDataService: PhotosDataServiceProtocol {
    
    let baseUrl = "https://api.vk.com/method/"
    let parser: PhotosParser
    
    init(parser: PhotosParser) {
        self.parser = parser
    }
    
    let apiKey = SessionData.shared.token
    
    func loadPhotosData(completion: @escaping ([Photo]) -> Void) {
        
        let parameters: Parameters = [
            "owner_id" : 1129934,
            "album_id" : "profile",
            "access_token" : apiKey,
            "v" : "5.103"
        ]
        
        let method = "photos.get"
        
        let url = baseUrl + method
        
        AF.request(url, parameters: parameters).responseJSON { [completion] (response) in
            if let error = response.error {
                print(error)
            } else {
                guard let data = response.data else { return }
                
                let photos: [Photo] = self.parser.parse(data: data)
                
                completion(photos)
            }
            
        }
    }
}

class UsersSwiftyJSONParser: UsersParser {
    
    func parse(data: Data) -> [User] {
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> User in
                
                let user = User()
                user.name = item["first_name"].stringValue + " " + item["last_name"].stringValue
                user.avatar = item["photo_200_orig"].stringValue
                
                return user
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}

class GroupsSwiftyJSONParser: GroupsParser {
    
    func parse(data: Data) -> [Group] {
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> Group in
                
                let group = Group()
                group.name = item["name"].stringValue
                group.avatar = item["photo_200"].stringValue
                
                return group
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}

class PhotosSwiftyJSONParser: PhotosParser {
    
    func parse(data: Data) -> [Photo] {
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
}

func getImageByURL(imageUrl: String) -> UIImage {
    let urlString = imageUrl
    let url = NSURL(string: urlString)! as URL
    var image: UIImage = .init()
    
    if let imageData: NSData = NSData(contentsOf: url) {
        image = UIImage(data: imageData as Data)!
    }
    
    return image
}

func prepareParams(method: String, parameters: Parameters) -> APIparams {
    var apiParams: APIparams = .init()
    
    let baseUrl = "https://api.vk.com/method/"
    
    let apiKey = SessionData.shared.token
    
    let defaultParams: Parameters = [
        "access_token" : apiKey,
        "v" : "5.103"
        
    ]
    
//    let parameters: Parameters = [
//        "owner_id" : 1129934,
//        "album_id" : "profile",
//
//    ]
    
    apiParams.url = baseUrl + method
    apiParams.parameters = defaultParams + parameters
    
    return apiParams
}
