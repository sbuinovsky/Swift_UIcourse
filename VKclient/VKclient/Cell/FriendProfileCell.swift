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
    //изображение аватара пользователя для временного хранения при анимации
    @IBOutlet weak var friendProfileImageTemp: UIImageView!
    //слой для отображение тени под аватаром
    @IBOutlet weak var friendProfileImageShadow: ImageShadow!
    //Имя пользователя под аватаром
    @IBOutlet weak var friendNameLabel: UILabel!
    
    
    let friendPhotos: [UIImage] = [
        UIImage(imageLiteralResourceName: "profileImage1"),
        UIImage(imageLiteralResourceName: "profileImage2"),
        UIImage(imageLiteralResourceName: "profileImage3"),
        UIImage(imageLiteralResourceName: "profileImage4"),
        UIImage(imageLiteralResourceName: "profileImage5"),
        UIImage(imageLiteralResourceName: "profileImage6"),
        UIImage(imageLiteralResourceName: "profileImage7")
    ]
    
    var counter = 0
    
    override func awakeFromNib() {
        
        // задаем распознавание swipe вправо-влево на картинке профиля
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        
        leftSwipeGesture.direction = .left
        rightSwipeGesture.direction = .right
        
        //добавляем распознавание свайпов к картинке профиля
        friendProfileImage.addGestureRecognizer(leftSwipeGesture)
        friendProfileImage.addGestureRecognizer(rightSwipeGesture)
        friendProfileImage.isUserInteractionEnabled = true

    }
    
    @objc public func onSwipe(_ sender: UISwipeGestureRecognizer) {
        
        // листание фото
        switch sender.direction {
        
        case .left:
            if counter >= (friendPhotos.count - 1) {
                friendProfileImage.image = friendPhotos.last
                
            } else {
                self.friendProfileImageTemp.image = friendProfileImage.image
                animationZoomOut()
                
                counter += 1
                
                self.friendProfileImage.image = friendPhotos[counter]
                animationRightToLeft()
                
            }

        case .right:
            if counter <= 0 {
                friendProfileImage.image = friendPhotos.first
                
            } else {
                self.friendProfileImageTemp.image = friendProfileImage.image
                animationZoomOut()
                
                counter -= 1
                
                self.friendProfileImage.image = friendPhotos[counter]
                animationLeftToRight()
            }
            
        default:
            return
        }
        
    }
    
    func animationLeftToRight() {
        friendProfileImage.transform = CGAffineTransform(translationX: -contentView.bounds.width, y: 0)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.friendProfileImage.transform = .identity
                        
        })
    }
    
    func animationRightToLeft() {
        friendProfileImage.transform = CGAffineTransform(translationX: contentView.bounds.width, y: 0)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.friendProfileImage.transform = .identity
                        
        })
        
    }
    
    func animationZoomOut() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 0.5
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 0.2
        scaleAnimation.beginTime = CACurrentMediaTime()
        
        friendProfileImageTemp.layer.add(scaleAnimation, forKey: nil)
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        friendProfileImage.image = nil
        friendProfileImageShadow = nil
        friendNameLabel.text = ""
    }
}
