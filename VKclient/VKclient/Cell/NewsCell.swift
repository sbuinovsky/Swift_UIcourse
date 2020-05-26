//
//  NewsTableViewCell.swift
//  VKclient
//
//  Created by Станислав Буйновский on 17.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }
    
    
    func setImage( image: UIImage? ) {
        guard let image = image else { return }
        newsImage.image = image
    }

}
