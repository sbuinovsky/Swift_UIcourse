//
//  News.swift
//  VKclient
//
//  Created by Станислав Буйновский on 02.04.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift

class News: Object {
    
    @objc dynamic var postId: Int = 0
    @objc dynamic var sourceId: Int = 0
    @objc dynamic var date: Date = Date()
    @objc dynamic var text: String = ""
    @objc dynamic var imageURL: String = ""
    
    
    override class func primaryKey() -> String? {
        return "postId"
    }
       
}
