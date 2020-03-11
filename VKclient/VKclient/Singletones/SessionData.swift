//
//  SessionData.swift
//  VKclient
//
//  Created by Станислав Буйновский on 11.03.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class SessionData {
    private var token: String
    private var userId: Int
    
    private init(token: String, userId: Int) {
        self.token = token
        self.userId = userId
    }
    
    static let shared: SessionData = .init(token: "", userId: 0)
    
    func tokenPush(_ newToken: String) {
        token = newToken
    }
    
    func tokenPop() -> String {
        return token
    }
    
    func userIdPush(_ newUserId: Int) {
        userId = newUserId
    }
    
    func userIdPop() -> Int {
        return userId
    }
    
    func pushNewData(_ newToken: String, _ newUserId: Int) {
        token = newToken
        userId = newUserId
    }
    
}

