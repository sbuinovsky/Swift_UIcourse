//
//  LoaderCirclesViewController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 25.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class LoaderCirclesViewController: UIViewController {

    @IBOutlet weak var firstCircle: UIView!
    @IBOutlet weak var secondCircle: UIView!
    @IBOutlet weak var thirdCircle: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //скругление аватара пользователя и добавление тени
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x:20, y:20), radius: 20, startAngle: 0, endAngle: 360, clockwise: true)
        
        let maskLayer1 = CAShapeLayer()
        maskLayer1.path = path.cgPath
        
        let maskLayer2 = CAShapeLayer()
        maskLayer2.path = path.cgPath
        
        let maskLayer3 = CAShapeLayer()
        maskLayer3.path = path.cgPath
        
        firstCircle.layer.mask = maskLayer1
        secondCircle.layer.mask = maskLayer2
        thirdCircle.layer.mask = maskLayer3
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveEaseIn],
                       animations: {
                        self.firstCircle.alpha = 0.5
        })
        
        UIView.animate(withDuration: 1,
                       delay: 0.6,
                       options: [.repeat, .autoreverse, .curveEaseIn],
                       animations: {
                        self.secondCircle.alpha = 0.5
        })
        
        UIView.animate(withDuration: 1,
                       delay: 1.2,
                       options: [.repeat, .autoreverse, .curveEaseIn],
                       animations: {
                        self.thirdCircle.alpha = 0.5
        })
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
