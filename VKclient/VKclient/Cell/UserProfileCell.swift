//
//  userProfileTVCCell.swift
//  VKclient
//
//  Created by Станислав Буйновский on 09.05.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import PromiseKit

class UserProfileCell: UITableViewCell {
    
    //изображение аватара пользователя
    @IBOutlet weak var userAvatar: UIImageView!
    //Имя пользователя под аватаром
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userSex: UILabel!
    @IBOutlet weak var userBdate: UILabel!
    @IBOutlet weak var userCity: UILabel!
    @IBOutlet weak var userCountry: UILabel!
    @IBOutlet weak var userHomeTown: UILabel!
    @IBOutlet weak var userOnline: UILabel!
    @IBOutlet weak var userDomain: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var userActivities: UITextView!
    @IBOutlet weak var userInterests: UITextView!
    @IBOutlet weak var userMusic: UITextView!
    @IBOutlet weak var userMovies: UITextView!
    @IBOutlet weak var userBooks: UITextView!
    @IBOutlet weak var userGames: UITextView!
    
    
    var userAvatarPromise: Promise<UIImage>? {
        didSet {
            userAvatarPromise?.done(on: DispatchQueue.main, { (image) in
                self.userAvatar.image = image
            })
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userAvatar.image = nil
        userName.text = "unknown"
        userSex.text = "unknown"
        userBdate.text = "unknown"
        userCity.text = "unknown"
        userCountry.text = "unknown"
        userHomeTown.text = "unknown"
        userOnline.text = "unknown"
        userDomain.text = "unknown"
        userStatus.text = "unknown"
        userNickname.text = "unknown"
        userActivities.text = "unknown"
        userInterests.text = "unknown"
        userMusic.text = "unknown"
        userMovies.text = "unknown"
        userBooks.text = "unknown"
        userGames.text = "unknown"
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //скругление аватара пользователя
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: userAvatar.bounds.width/2, y: userAvatar.bounds.height/2), radius: userAvatar.bounds.width/2, startAngle: 0, endAngle: 360, clockwise: true)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        userAvatar.layer.mask = maskLayer
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
