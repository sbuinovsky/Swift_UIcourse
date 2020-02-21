//
//  FriendCell.swift
//  VKclient
//
//  Created by Станислав Буйновский on 10.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    @IBOutlet weak var friendAvatarImage: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        friendAvatarImage.image = nil
        friendNameLabel.text = ""
    }
    
}
