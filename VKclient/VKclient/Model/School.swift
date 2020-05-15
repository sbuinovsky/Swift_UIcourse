//
//  University.swift
//  VKclient
//
//  Created by Станислав Буйновский on 11.05.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift

class School: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var country: Int = 0
    @objc dynamic var city: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var yearFrom: Int = 0
    @objc dynamic var yearTo: Int = 0
    @objc dynamic var yearGraduated: Int = 0
    @objc dynamic var classLetter: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
