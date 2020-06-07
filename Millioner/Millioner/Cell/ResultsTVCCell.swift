//
//  ResultsTVCCell.swift
//  Millioner
//
//  Created by Станислав Буйновский on 04.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class ResultsTVCCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var persentageLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
