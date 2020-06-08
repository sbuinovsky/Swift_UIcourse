//
//  SettingsVC.swift
//  Millioner
//
//  Created by Станислав Буйновский on 07.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var difficulty: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Game.shared.difficulty == .hard {
            difficulty.selectedSegmentIndex = 1
        } else {
            difficulty.selectedSegmentIndex = 0
        }

    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        switch difficulty.selectedSegmentIndex {
        case 1:
            Game.shared.saveDifficulty(value: .hard)
        default:
            Game.shared.saveDifficulty(value: .easy)
        }
    }

}
