//
//  Group.swift
//  VKclient
//
//  Created by Станислав Буйновский on 10.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift

class Group: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var avatar: String = ""

}
