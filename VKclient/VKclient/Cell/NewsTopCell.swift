//
//  NewsTopCell.swift
//  VKclient
//
//  Created by Станислав Буйновский on 20.05.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

protocol NewsTopCellDelegate: class {
    func showMoreTapped(indexPath: IndexPath)
}

class NewsTopCell: UITableViewCell {
    
    @IBOutlet weak var sourceImage: UIImageView!
    @IBOutlet weak var sourceName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var newsTextHeight: NSLayoutConstraint!
    
    weak var delegate: NewsTopCellDelegate?
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: sourceImage.bounds.width/2, y: sourceImage.bounds.height/2), radius: sourceImage.bounds.width/2, startAngle: 0, endAngle: 360, clockwise: true)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        sourceImage.layer.mask = maskLayer
        
        showMoreButton.setTitleColor(UIColor.vkBlue, for: .normal)
    }
    
    
    func setupCell() {
        if newsText.text == "" {
            newsTextHeight.constant = 0
            showMoreButton.isHidden = true
        }
        else if newsText.text.count < 200 {
            showMoreButton.isHidden = true
        }
        else {
            showMoreButton.isHidden = false
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func showMoreButtonTapped(_ sender: AnyObject) {
        guard let index = indexPath else { return }
        delegate?.showMoreTapped(indexPath: index)
    }
    
    func getRowHeightFromText(text : String!) -> CGFloat
    {
        let textView = UITextView(frame: CGRect(x: self.newsText.frame.origin.x,
                                                y: 0,
                                                width: self.newsText.frame.size.width,
                                                height: 0))
        textView.text = text
        textView.sizeToFit()
        
        var textFrame : CGRect! = CGRect()
        textFrame = textView.frame
        
        var size : CGSize! = CGSize()
        size = textFrame.size
        
        size.height = textFrame.size.height
        
        return size.height
    }
}
