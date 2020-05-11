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
    func friendsParser(data: Data) -> [User]
    func educationParser(data: Data) -> Education
    func groupsParser(data: Data) -> [Group]
    func photosParser(data: Data) -> [Photo]
    func newsParser(data: Data) -> [News]
    func sourceGroupsParser(data: Data) -> [NewsSource]
    func sourceUsersParser(data: Data) -> [NewsSource]
}

class ParserService: ParserServiceProtocol {
    
    private let firebaseService: FirebaseServiceProtocol = FirebaseService()
    private let realmService: RealmService = .init()
    
    
    func friendsParser(data: Data) -> [User] {

        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> User in
                
                let user = User()
                user.id = item["id"].intValue
                user.firstName = item["first_name"].stringValue
                user.lastName = item["last_name"].stringValue
                user.name = user.firstName + " " + user.lastName
                user.sex = item["sex"].intValue
                user.bdate = item["bdate"].stringValue
                user.city  = item["city"].stringValue
                user.country = item["country"].stringValue
                user.homeTown = item["home_town"].stringValue
                user.online = item["online"].intValue
                user.domain = item["domain"].stringValue
                user.status = item["status"].stringValue
                user.nickname = item["nickname"].stringValue
                user.activities = item["activities"].stringValue
                user.interests = item["interests"].stringValue
                user.music = item["music"].stringValue
                user.movies = item["movies"].stringValue
                user.books = item["books"].stringValue
                user.games = item["games"].stringValue
                user.avatar = item["photo_100"].stringValue
                
                firebaseService.updateFriends(object: user)
                
                return user
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    
    func educationParser(data: Data) -> Education {
        
        do {
            let json = try JSON(data: data)
            let array = json["response"].arrayValue
            
            let result = array.map { item -> Education in
                
                let education = Education()
                
                let universities = item["universities"].arrayValue
                
                education.universities = universities.map { item -> University in
                    
                    let university = University()
                    
                    university.id = item["id"].intValue
                    university.country = item["country"].intValue
                    university.city = item["city"].intValue
                    university.name = item["name"].stringValue
                    university.faculty = item["faculty"].intValue
                    university.facultyName = item["faculty_name"].stringValue
                    university.chair = item["chair"].intValue
                    university.chairName = item["chair_name"].stringValue
                    university.graduation = item["graduation"].intValue
                    university.educationForm = item["education_form"].stringValue
                    university.educationStatus = item["education_status"].stringValue
                    
                    return university
                }
                
                let schools = item["schools"].arrayValue
                
                education.schools = schools.map { item -> School in
                    
                    let school = School()
                    
                    school.id = item["id"].intValue
                    school.country = item["country"].intValue
                    school.city = item["city"].intValue
                    school.name = item["name"].stringValue
                    school.yearFrom = item["year_from"].intValue
                    school.yearTo = item["year_to"].intValue
                    school.yearGraduated = item["year_graduated"].intValue
                    school.classLetter = item["class"].stringValue
                    
                    return school
                }
                
                return education
            }
            
            guard let resultEducation = result.first else { return Education() }
            
            return resultEducation
            
        } catch {
            print(error.localizedDescription)
            return Education()
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
                group.avatar = item["photo_100"].stringValue
                
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
                if let first = photoSet?.first (where: { $0["type"].stringValue == "p" } ) {
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
                sourceGroup.avatar = item["photo_100"].stringValue
                
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
