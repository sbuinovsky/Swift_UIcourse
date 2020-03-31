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
    @objc dynamic var avatar: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
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
