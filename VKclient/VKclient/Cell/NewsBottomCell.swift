//
//  NewsBottomCell.swift
//  VKclient
//
//  Created by Станислав Буйновский on 20.05.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class NewsBottomCell: UITableViewCell {
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeCounter: UILabel!
    @IBOutlet weak var shareButton: UIImageView!
    @IBOutlet weak var commentsImage: UIImageView!
    @IBOutlet weak var commentsCounter: UILabel!
    @IBOutlet weak var viewsImage: UIImageView!
    @IBOutlet weak var viewsCounter: UILabel!
    @IBOutlet weak var repostImage: UIImageView!
    @IBOutlet weak var repostCounter: UILabel!
    
    private let likeBox: Like = .init()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        
        likeImage.addGestureRecognizer(tapGesture)
        likeImage.isUserInteractionEnabled = true
    }

    
    @objc func onTap(_ sender: UIGestureRecognizer) {
        print(#function)
        
        if let string = likeCounter.text, let counter = Int(string) {
            
            if likeBox.active == false {
                likeBox.active = true
                likeBox.counter = counter + 1
                likeCounter.text = "\(likeBox.counter)"
                likeImage.image = UIImage(imageLiteralResourceName: "likeImageActive")
            } else {
                likeBox.active = false
                likeBox.counter = counter - 1
                likeCounter.text = "\(likeBox.counter)"
                likeImage.image = UIImage(imageLiteralResourceName: "likeImageDefault")
            }
        }
            
        
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 20,
                       options: .curveEaseInOut,
                       animations: {
                        self.likeImage.center.y += 4
        })
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
