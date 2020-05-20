//
//  NewsTopCell.swift
//  VKclient
//
//  Created by Станислав Буйновский on 20.05.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class NewsTopCell: UITableViewCell {

    @IBOutlet weak var sourceImage: UIImageView!
    @IBOutlet weak var sourceName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var newsText: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         let path = UIBezierPath()
         path.addArc(withCenter: CGPoint(x: sourceImage.bounds.width/2, y: sourceImage.bounds.height/2), radius: sourceImage.bounds.width/2, startAngle: 0, endAngle: 360, clockwise: true)
         let maskLayer = CAShapeLayer()
         maskLayer.path = path.cgPath
         
        sourceImage.layer.mask = maskLayer
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
