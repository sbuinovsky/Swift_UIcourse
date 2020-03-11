//
//  SessionData.swift
//  VKclient
//
//  Created by Станислав Буйновский on 11.03.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class SessionData {
    var token: String = .init()
    var userId: Int = .init()
    
    private init() {}
    
    static let shared: SessionData = .init()
}
