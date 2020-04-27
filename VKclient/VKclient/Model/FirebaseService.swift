//
//  FirebaseService.swift
//  VKclient
//
//  Created by Станислав Буйновский on 07.04.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol FirebaseServiceProtocol {
    func anonymousAuth()
    func updateFriends(object: User)
    func updateGroups(object: Group)
    func updateNewsSource(object: NewsSource)
}

private let queue = DispatchQueue(label: "FirebaseService_queue")

class FirebaseService: FirebaseServiceProtocol {
    
    private let db = Database.database().reference()
    private let userUID = SessionData.shared.userUID
    
    func anonymousAuth() {
        
        Auth.auth().signInAnonymously { (result, error) in
            
            let appUsersPath = self.db.child("appusers")
            
            guard let userUID = result?.user.uid else { return }
            
            SessionData.shared.userUID = userUID
            
            let deviceID = UIDevice.current.name + " " + UIDevice.current.systemVersion
            
            if appUsersPath.isEqual( "\(userUID)" ) == false {
                
                appUsersPath.child("\(userUID)").updateChildValues([ "device" : "\(deviceID)" ])
                
            }
                
        }
    }
    
    
    func updateFriends(object: User) {
        
        let friendsPath = self.db.queryOrdered(byChild: "appusers/\(self.userUID)/friends")
        
        if friendsPath.isEqual("\(object.id)") == false {
            
            self.db.child("appusers/\(self.userUID)/friends/\(object.id)").updateChildValues([ "id" : "\(object.id)" ])
            self.db.child("appusers/\(self.userUID)/friends/\(object.id)").updateChildValues([ "name" : "\(object.name)" ])
            
        }
        
        
    }
    
    
    func updateGroups(object: Group) {
        
        
        let groupsPath = self.db.queryOrdered(byChild: "appusers/\(self.userUID)/groups")
        
        if groupsPath.isEqual("\(object.id)") == false {
            
            self.db.child("appusers/\(self.userUID)/groups/\(object.id)").updateChildValues([ "id" : "\(object.id)" ])
            self.db.child("appusers/\(self.userUID)/groups/\(object.id)").updateChildValues([ "name" : "\(object.name)" ])
            
        }
        
        
    }
    
    func updateNewsSource(object: NewsSource) {
        
        
        let newsSourcesPath = self.db.queryOrdered(byChild: "appusers/\(self.userUID)/newsSources")
        
        if newsSourcesPath.isEqual("\(object.id)") == false {
            
            self.db.child("appusers/\(self.userUID)/newsSources/\(object.id)").updateChildValues([ "id" : "\(object.id)" ])
            self.db.child("appusers/\(self.userUID)/newsSources/\(object.id)").updateChildValues([ "name" : "\(object.name)" ])
            
        }
        
    }
    
}
