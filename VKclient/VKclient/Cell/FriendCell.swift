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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //скругление аватара пользователя
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: friendAvatarImage.bounds.width/2, y: friendAvatarImage.bounds.height/2), radius: friendAvatarImage.bounds.width/2, startAngle: 0, endAngle: 360, clockwise: true)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        friendAvatarImage.layer.mask = maskLayer
        
        //добавляем обработку нажатия на элемент
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        
        friendAvatarImage.addGestureRecognizer(tapGesture)
        friendAvatarImage.isUserInteractionEnabled = true
        
    }
    
    
    @objc func onTap(_ sender: UIGestureRecognizer) {
        print(#function)
        
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       animations: {
                        self.friendAvatarImage.transform = .init(scaleX: 0.9, y: 0.9)
        })
        
        UIView.animate(withDuration: 1,
                       delay: 0.2,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 30,
                       animations: {
                        self.friendAvatarImage.transform = .init(scaleX: 1, y: 1)
        })
    }
    
}
