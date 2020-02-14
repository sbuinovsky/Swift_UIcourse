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
    @IBOutlet weak var FriendProfileImage: UIImageView!
    //слой для отображение тени под аватаром
    @IBOutlet weak var FriendProfileImageShadow: FriendProfileImageShadow!
    //изображение иконки счетчика лайков
    @IBOutlet weak var FriendLikeCounterImage: UIImageView!
    //счетчик количества лайков на иконке
    @IBOutlet weak var FriendLikeCounterLabel: UILabel!
    
}
