//
//  School.swift
//  VKclient
//
//  Created by Станислав Буйновский on 11.05.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift

class University: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var country: Int = 0
    @objc dynamic var city: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var faculty: Int = 0
    @objc dynamic var facultyName: String = ""
    @objc dynamic var chair: Int = 0
    @objc dynamic var chairName: String = ""
    @objc dynamic var graduation: Int = 0
    @objc dynamic var educationForm: String = ""
    @objc dynamic var educationStatus: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
