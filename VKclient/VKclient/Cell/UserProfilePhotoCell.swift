//
//  UserProfilePhotoCell.swift
//  VKclient
//
//  Created by Станислав Буйновский on 10.05.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import PromiseKit

class UserProfilePhotoCell: UICollectionViewCell {
    @IBOutlet weak var userProfilePhoto: UIImageView!
    
    var userProfilePhotoPromise: Promise<UIImage>? {
        didSet {
            userProfilePhotoPromise?.done(on: DispatchQueue.main, { (image) in
                self.userProfilePhoto.image = image
            })
        }
    }
}
