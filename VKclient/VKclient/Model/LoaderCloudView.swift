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
        
       // Здесь будем рисовать облачко
        
    }
    
    public func animateLoader() {
        
        // Здесь будем анимировать облачко
               
    }
}
