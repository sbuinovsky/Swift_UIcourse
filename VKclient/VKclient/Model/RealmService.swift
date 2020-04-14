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
    
    func saveObjects(objects: [Object]) throws
    func saveObject(object: Object) throws
    func getUsers() -> [User]
    func getGroups() -> [Group]
    func getGroupById(id: Int) -> Group?
    func getUserPhotos(ownerId: Int) -> [Photo]
    func deleteObject(object: Object) throws
}

class RealmService: RealmServiceProtocol {
    
    
    func saveObjects(objects: [Object]) {
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
    
    func saveObject(object: Object) {
        do {
            Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm()
            realm.beginWrite()
            realm.add(object, update: .modified)
            try realm.commitWrite()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    func deleteObject(object: Object) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(object)
            try realm.commitWrite()
        } catch {
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
    
    func getGroupById(id: Int) -> Group? {
        do {
            let realm = try Realm()
            let group = realm.objects(Group.self).filter("id = %@", abs(id)).first
            return group
            
        } catch {
            print(error.localizedDescription)
            return Group()
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
