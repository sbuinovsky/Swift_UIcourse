//
//  FriendProfileCell.swift
//  VKclient
//
//  Created by Станислав Буйновский on 10.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class FriendProfileCell: UICollectionViewCell {
    //изображение аватара пользователя
    @IBOutlet weak var friendProfileImage: UIImageView!
    //слой для отображение тени под аватаром
    @IBOutlet weak var friendProfileImageShadow: FriendProfileImageShadow!
    //Имя пользователя под аватаром
    @IBOutlet weak var friendNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        friendProfileImage.image = nil
        friendProfileImageShadow = nil
        friendNameLabel.text = ""
    }
}
