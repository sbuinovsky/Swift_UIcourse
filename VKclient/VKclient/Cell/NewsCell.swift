//
//  NewsTableViewCell.swift
//  VKclient
//
//  Created by Станислав Буйновский on 17.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeCounter: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var shareButton: UIImageView!
    @IBOutlet weak var commentsButton: UIImageView!
    @IBOutlet weak var viewsImage: UIImageView!
    @IBOutlet weak var viewsCounter: UILabel!
    
    
    
    //инициализируем базовый объект Like
    let likeBox = Like()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //добавляем обработку нажатия на элемент
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        
        likeImage.addGestureRecognizer(tapGesture)
        likeImage.isUserInteractionEnabled = true
        
    }
    
    
    @objc func onTap(_ sender: UIGestureRecognizer) {
        print(#function)
        if likeBox.active == false {
            likeBox.active = true
            likeBox.counter += 1
            likeCounter.text = "\(likeBox.counter)"
            likeImage.image = UIImage(imageLiteralResourceName: "likeImageActive")
        } else {
            likeBox.active = false
            likeBox.counter -= 1
            likeCounter.text = "\(likeBox.counter)"
            likeImage.image = UIImage(imageLiteralResourceName: "likeImageDefault")
        }
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 20,
                       options: .curveEaseInOut,
                       animations: {
                        self.likeImage.center.y += 4
                        self.likeCounter.center.y += 4
        })
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        groupImage.image = nil
        groupName.text = ""
        date.text = ""
        textField.text = ""
        likeImage.image = nil
        likeCounter.text = ""
        newsImage.image = nil
        shareButton.image = nil
        commentsButton.image = nil
        viewsImage.image = nil
        viewsCounter.text = ""
        
    }

}
