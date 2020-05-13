//
//  UserProfileEducationCell.swift
//  VKclient
//
//  Created by Станислав Буйновский on 13.05.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import PromiseKit

class UserProfileEducationCell: UITableViewCell {

    @IBOutlet weak var userUniversities: UITextView!
    @IBOutlet weak var userUniversitiesHeight: NSLayoutConstraint!
    @IBOutlet weak var userSchools: UITextView!
    @IBOutlet weak var userSchoolsHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
