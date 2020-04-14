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
    @objc dynamic var date: Double = 0
    @objc dynamic var text: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var views: Int = 0
    @objc dynamic var likes: Int = 0
    @objc dynamic var comments: Int = 0
    
    override class func primaryKey() -> String? {
        return "postId"
    }
       
}
