//
//  Shadow.swift
//  VKclient
//
//  Created by Станислав Буйновский on 27.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class ImageShadow: UIImageView {
    // класс для формирования тени
    
    // основные параметры
    @IBInspectable var shadowColor: UIColor = .black
    @IBInspectable var shadowRadius: CGFloat = 6
    @IBInspectable var shadowOpacity: Float = 0.9
    
    //метод для формирования тени
    func addShadow() {
        layer.masksToBounds = false
        layer.cornerRadius = 125
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize.zero
    }
}
