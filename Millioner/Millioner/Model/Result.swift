//
//  Result.swift
//  Millioner
//
//  Created by Станислав Буйновский on 03.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import RealmSwift

class Result: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var percentage: Double = 0.0
    @objc dynamic var balance: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
