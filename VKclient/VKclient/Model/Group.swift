//
//  Group.swift
//  VKclient
//
//  Created by Станислав Буйновский on 10.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class Group: Equatable {
    
    let name: String
    let avatar: UIImage
    
    init(name: String, avatar: UIImage) {
        self.name = name
        self.avatar = avatar
    }
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        lhs.name == rhs.name
    }
}
