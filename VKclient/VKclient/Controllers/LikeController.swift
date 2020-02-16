//
//  LikeController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 14.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class LikeController: UIViewController {
    
    //изображение иконки счетчика лайков
    @IBOutlet weak var friendLikeCounterImage: UIImageView!
    //счетчик количества лайков на иконке
    @IBOutlet weak var friendLikeCounterLabel: UILabel!
    
    //создаем объект Like по-умолчанию
    var likeBox = Like()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //добавляем обработку нажатия на элемент
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        friendLikeCounterImage.addGestureRecognizer(tapGesture)
        friendLikeCounterImage.isUserInteractionEnabled = true
        
        
    }
    
    @objc func onTap(_ sender: UIGestureRecognizer) {
        print(#function)
        if likeBox.active == false {
            likeBox.active = true
            likeBox.counter += 1
            friendLikeCounterLabel.text = "\(likeBox.counter)"
            friendLikeCounterImage.image = UIImage(imageLiteralResourceName: "likeImageActive")
        } else {
            likeBox.active = false
            likeBox.counter -= 1
            friendLikeCounterLabel.text = "\(likeBox.counter)"
            friendLikeCounterImage.image = UIImage(imageLiteralResourceName: "likeImageDefault")
       }
    }

}
