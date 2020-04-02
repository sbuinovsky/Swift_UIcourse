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
    
    func saveData(objects: [Object]) throws
    func getUsers() -> [User]
    func getGroups() -> [Group]
    func getUserPhotos(ownerId: Int) -> [Photo]
}

class RealmService: RealmServiceProtocol {
    
    
    func saveData(objects: [Object]) {
        do {
            Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm()
            print(realm.configuration.fileURL)
            realm.beginWrite()
            realm.add(objects, update: .modified)
            try realm.commitWrite()
        }
        catch {
            print(error.localizedDescription)
        }
    }

    
    func getUsers() -> [User] {
        do {
            let realm = try Realm()
            let objects = realm.objects(User.self)
            return Array(objects)
            
        } catch {
            print(error.localizedDescription)
            return []
        }

    }
    
    
    func getGroups() -> [Group] {
        do {
            let realm = try Realm()
            let objects = realm.objects(Group.self)
            return Array(objects)
            
        } catch {
            print(error.localizedDescription)
            return []
        }

    }
    
    
    func getUserPhotos(ownerId: Int) -> [Photo] {
        do {
            let realm = try Realm()
            let photos = realm.objects(Photo.self).filter("ownerId = %@", ownerId)
            return Array(photos)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
