//
//  LoaderCloudView.swift
//  VKclient
//
//  Created by Станислав Буйновский on 28.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class LoaderCloudView: UIView {
    
    let cloud = UIView()
    
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        initLoader()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initLoader()
    }
    
    
    private func initLoader() {
        addSubview(cloud)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let cloudPath = UIBezierPath()
        cloudPath.move(to:.init(x: bounds.width/3, y: bounds.height))
        cloudPath.addArc(withCenter: CGPoint(x: bounds.width/3, y: 3*bounds.height/4),
                         radius: bounds.height/4,
                         startAngle: .pi/2,
                         endAngle: .pi/2*3,
                         clockwise: true)
        
        cloudPath.addArc(withCenter: CGPoint(x: bounds.width/2, y: bounds.height/2),
                         radius: bounds.height/4,
                         startAngle: .pi,
                         endAngle: .pi*2,
                         clockwise: true)
        
        cloudPath.addArc(withCenter: CGPoint(x: 2*bounds.width/3, y: 3*bounds.height/4),
                         radius: bounds.height/4,
                         startAngle: .pi/2*3,
                         endAngle: .pi/2,
                         clockwise: true)
        
        cloudPath.addLine(to: CGPoint(x: bounds.width/3, y: bounds.height))
        
        cloudPath.close()
        cloudPath.stroke()
        
        let cloudLayer = CAShapeLayer()
        cloudLayer.strokeColor = UIColor.darkGray.cgColor
        cloudLayer.fillColor = UIColor.gray.cgColor
        cloudLayer.lineWidth = 5
        cloudLayer.lineCap = .round

        cloudLayer.path = cloudPath.cgPath
        cloud.layer.addSublayer(cloudLayer)
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 2
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 3.0
        animationGroup.repeatCount = .infinity
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        
        cloudLayer.add(animationGroup, forKey: nil)
        
    }
    
}
