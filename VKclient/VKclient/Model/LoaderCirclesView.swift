//
//  LoaderCirclesView.swift
//  VKclient
//
//  Created by Станислав Буйновский on 25.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class LoaderCirclesView: UIView {
    let firstCircle = UIView()
    let secondCircle = UIView()
    let thirdCircle = UIView()
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        initLoader()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initLoader()
    }
    
    private func initLoader() {
        addSubview(firstCircle)
        addSubview(secondCircle)
        addSubview(thirdCircle)
        firstCircle.backgroundColor = .gray
        secondCircle.backgroundColor = .gray
        thirdCircle.backgroundColor = .gray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let indent: CGFloat = 4
        let circleDiameter = bounds.height - indent
        let circleStep = bounds.width/3 + (indent*2)
        let cornerRadiusSize = circleDiameter/2
        
        //создаемся фреймы
        firstCircle.frame = CGRect(x: 0, y: 0, width: circleDiameter, height: circleDiameter)
        secondCircle.frame = CGRect(x: circleStep, y: 0, width: circleDiameter, height: circleDiameter)
        thirdCircle.frame = CGRect(x: circleStep*2, y: 0, width: circleDiameter, height: circleDiameter)
        
        //скругляем углы так чтобы получились кружки
        firstCircle.layer.cornerRadius = cornerRadiusSize
        secondCircle.layer.cornerRadius = cornerRadiusSize
        thirdCircle.layer.cornerRadius = cornerRadiusSize
        
    }
    
    public func animateLoader() {
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
    
    public func stopAnimateLoader() {
        firstCircle.layer.removeAllAnimations()
        secondCircle.layer.removeAllAnimations()
        thirdCircle.layer.removeAllAnimations()
    }
}
