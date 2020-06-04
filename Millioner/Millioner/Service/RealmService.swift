//
//  RealmService.swift
//  Millioner
//
//  Created by Станислав Буйновский on 04.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift

protocol RealmServiceProtocol {
    
    func saveResults(results: [Result]) throws
    func getResults() -> [Result]
}

class RealmService: RealmServiceProtocol {
    
    func saveResults(results: [Result]) {
        do {
            Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm()
            print(realm.configuration.fileURL)
            realm.beginWrite()
            realm.add(results, update: .modified)
            try realm.commitWrite()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func getResults() -> [Result] {
        do {
            let realm = try Realm()
            let objects = realm.objects(Result.self)
            return Array(objects)
            
        } catch {
            print(error.localizedDescription)
            return []
        }

    }
    
}
