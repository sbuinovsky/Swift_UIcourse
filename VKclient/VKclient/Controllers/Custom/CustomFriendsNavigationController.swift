//
//  CustomFriendsNavigationController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 01.03.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class CustomFriendsNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    private let interactiveTransition = CustomInteractiveTransition()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    
    }
    
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            interactiveTransition.viewController = toVC
            return CustomPushAnimator()
            
        }
        else if operation == .pop {
            interactiveTransition.viewController = toVC
            return CustomPopAnimator()
            
        }
        
        return nil
    }
}
