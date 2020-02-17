//
//  FriendProfileController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FriendProfileCollectionViewController: UICollectionViewController {
    var friendName: String?
    var friendAvatar: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //количество секций
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //количество ячеек в секции
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendProfileCell", for: indexPath) as! FriendProfileCell
        
        //задаем имя пользователя
        cell.friendNameLabel.text = friendName
        cell.friendProfileImage.image = friendAvatar
        
        //скругление аватара пользователя и добавление тени
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: 125, y:125), radius: 125, startAngle: 0, endAngle: 360, clockwise: true)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath

        cell.friendProfileImage.image = UIImage(imageLiteralResourceName: "friendImage")
        cell.friendProfileImage.layer.mask = maskLayer
        cell.friendProfileImageShadow.addShadow()

        return cell
    }
    
}


@IBDesignable class FriendProfileImageShadow: UIView {
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
