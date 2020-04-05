//
//  GroupCell.swift
//  VKclient
//
//  Created by Станислав Буйновский on 10.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    @IBOutlet weak var favoriteGroupAvatarImage: UIImageView!
    @IBOutlet weak var favoriteGroupNameLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteGroupAvatarImage.image = nil
        favoriteGroupNameLabel.text = ""
    }
}
