//
//  CustomFriendsNavigationController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 01.03.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class CustomFriendsNavigationController: UINavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            return CustomPushAnimator()
            
        }
        else if operation == .pop {
            return CustomPopAnimator()
            
        }
        
        return nil
    }
}
