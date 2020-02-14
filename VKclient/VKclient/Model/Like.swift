//
//  Like.swift
//  VKclient
//
//  Created by Станислав Буйновский on 14.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class Like {
    var image: UIImage
    var active: Bool = false
    var counter: Int = 0
    
    init(image: UIImage? = UIImage(imageLiteralResourceName: "likeImageDefault"), active: Bool? = false, counter: Int? = 0) {
        self.image = image ?? UIImage(imageLiteralResourceName: "likeImageDefault")
        self.active = active ?? false
        self.counter = counter ?? 0
       
    }
    
}
