//
//  Photo.swift
//  VKclient
//
//  Created by Станислав Буйновский on 21.03.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift

class Photo: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var imageUrl: String = ""
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
