//
//  FooterGameTVCCell.swift
//  Millioner
//
//  Created by Станислав Буйновский on 03.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class FooterGameTVCCell: UITableViewCell {

    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var resultMessageLabel: UILabel!
    @IBOutlet weak var gameProgress: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
