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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //скругление аватара группы
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: favoriteGroupAvatarImage.bounds.width/2, y: favoriteGroupAvatarImage.bounds.height/2), radius: favoriteGroupAvatarImage.bounds.width/2, startAngle: 0, endAngle: 360, clockwise: true)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        favoriteGroupAvatarImage.layer.mask = maskLayer
    }
    
}
