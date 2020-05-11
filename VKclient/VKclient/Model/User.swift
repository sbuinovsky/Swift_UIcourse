//
//  User.swift
//  VKclient
//
//  Created by Станислав Буйновский on 10.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift

class User: Object, Comparable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var avatar: String = ""
    @objc dynamic var sex: Int = 0
    @objc dynamic var bdate: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var homeTown: String = ""
    @objc dynamic var online: Int = 0
    @objc dynamic var domain: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var nickname: String = ""
    @objc dynamic var activities: String = ""
    @objc dynamic var interests: String = ""
    @objc dynamic var music: String = ""
    @objc dynamic var movies: String = ""
    @objc dynamic var books: String = ""
    @objc dynamic var games: String = ""
    var education: Education = .init()
    var career: String = ""
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override class func ignoredProperties() -> [String] {
        return ["education","career"]
    }
    
    static func < (lhs: User, rhs: User) -> Bool {
     if lhs.name.startIndex < rhs.name.startIndex {
            return lhs.name < rhs.name
     } else {
        return false
        }
    }
    
    
    static func > (lhs: User, rhs: User) -> Bool {
     if lhs.name.startIndex > rhs.name.startIndex {
            return lhs.name > rhs.name
     } else {
        return false
        }
    }
    
    
    static func == (lhs: User, rhs: User) -> Bool {
        if lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
}
