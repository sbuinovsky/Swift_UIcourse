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
        
        let firebaseService: FirebaseService = .init()
        
        firebaseService.anonymousAuth()
        
        if SessionData.shared.token != "" {
            performSegue(withIdentifier: "ToTabBarController", sender: AnyObject.self)
        }
    
    }
    
}
