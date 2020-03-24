//
//  RealmService.swift
//  VKclient
//
//  Created by Станислав Буйновский on 24.03.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmServiceProtocol {
    func save(objects: [Object]) throws
    func loadUsers() -> [User]
}

class RealmService: Object, RealmServiceProtocol {
    
    func save(objects: [Object]) throws {
        let realm = try Realm()
        
        realm.beginWrite()
        realm.add(objects)
        try realm.commitWrite()
    }

    func loadUsers() -> [User] {
        do {
            let realm = try Realm()
            let objects = realm.objects(User.self)
            return Array(objects)
            
        } catch {
            return []
        }

    }
}
