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

private let apiKey = SessionData.shared.token

private let baseUrl = "https://api.vk.com/method/"

private var parameters: Parameters = [
    "access_token" : apiKey,
    "v" : "5.103"
]

private enum apiMethods: String {
    case friends = "friends.get"
    case groups = "groups.get"
    case photos = "photos.get"
    case groupsSearch = "groups.search"
}

protocol UsersDataServiceProtocol {
    func loadData(additionalParameters: [String : Any], completion: @escaping ([User]) -> Void)
}

protocol UsersParser {
    func parse(data: Data) -> [User]
}

protocol GroupsDataServiceProtocol {
    func loadData(additionalParameters: [String : Any], completion: @escaping ([Group]) -> Void)
}

protocol GroupsParser {
    func parse(data: Data) -> [Group]
}

protocol PhotosDataServiceProtocol {
    func loadData(additionalParameters: [String : Any], completion: @escaping ([Photo]) -> Void)
}

protocol PhotosParser {
    func parse(data: Data) -> [Photo]
}

class APIparams {
    var url: String = ""
    var parameters: Parameters = [ : ]
}

class UsersDataService: UsersDataServiceProtocol {

    let parser: UsersParser
    
    init(parser: UsersParser) {
        self.parser = parser
    }
    
    func loadData(additionalParameters: [String : Any], completion: @escaping ([User]) -> Void) {
        
        additionalParameters.forEach { (k,v) in parameters[k] = v }
        
        let url = baseUrl + apiMethods.friends.rawValue
        
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
    
    let parser: GroupsParser
    
    init(parser: GroupsParser) {
        self.parser = parser
    }
    
    func loadData(additionalParameters: [String : Any], completion: @escaping ([Group]) -> Void) {

        additionalParameters.forEach { (k,v) in parameters[k] = v }
        
        let url = baseUrl + apiMethods.groups.rawValue
        
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
    
    let parser: PhotosParser
    
    init(parser: PhotosParser) {
        self.parser = parser
    }
    
    func loadData(additionalParameters: [String : Any], completion: @escaping ([Photo]) -> Void) {
        
        additionalParameters.forEach { (k,v) in parameters[k] = v }
        
        let url = baseUrl + apiMethods.photos.rawValue
        
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
                user.id = item["id"].intValue
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
                if let first = sizeValues.first {
                    photo.imageUrl = first["url"].stringValue
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
