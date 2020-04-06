//
//  StartVC.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.04.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class StartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().signInAnonymously { (result, error) in

            let db = Database.database().reference()
            
            guard let userUID = result?.user.uid else { return }
            let deviceID = UIDevice.current.name + " " + UIDevice.current.systemVersion
            
            if db.queryOrdered(byChild: "appusers").isEqual(["\(String(describing: userUID)))" : "\(deviceID)"]) == false {
                
                db.child("appusers").updateChildValues(["\(String(describing: userUID)))" : "\(deviceID)"])
                SessionData.shared.userUID = userUID
            }
                
        }
        
    }
    
}
