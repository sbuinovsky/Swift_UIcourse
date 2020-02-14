//
//  FriendProfileController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 06.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

//создаем объект Like по-умолчанию
let likeBox = Like()

class FriendProfileController: UICollectionViewController {
    
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
        
        //скругление аватара пользователя и добавление тени
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: 125, y:125), radius: 125, startAngle: 0, endAngle: 360, clockwise: true)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath

        cell.FriendProfileImage.image = UIImage(imageLiteralResourceName: "friendImage")
        cell.FriendProfileImage.layer.mask = maskLayer
        cell.FriendProfileImageShadow.addShadow()
        
        //обработка лайков
        
        //создаем объект по-умолчанию
        let likeBox = Like()

        //добавляем обработку нажатия на элемент
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        cell.FriendLikeCounterImage.addGestureRecognizer(tapGesture)
        cell.FriendLikeCounterImage.isUserInteractionEnabled = true
        
        //Задание состояния блока Like
        cell.FriendLikeCounterImage.image = likeBox.image
        cell.FriendLikeCounterLabel.text = "\(likeBox.counter)"
        
        return cell
    }
    
    
    @objc func onTap(_ sender: UIGestureRecognizer) {
        print(#function)
        if likeBox.active == false {
            likeBox.active = true
            likeBox.counter += 1
            likeBox.image = UIImage(imageLiteralResourceName: "likeImageActive")
        } else {
            likeBox.active = false
            likeBox.counter -= 1
            likeBox.image = UIImage(imageLiteralResourceName: "likeImageDefault")
       }
            self.collectionView.reloadData()
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
