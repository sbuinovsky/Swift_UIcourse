//
//  GameSession.swift
//  Millioner
//
//  Created by Станислав Буйновский on 03.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class GameSession {

    var questions: Int = 0
    var answers = Observable<Int>(0)
    var balance: Int = 0
    
    var persentage: Double {
        return Double(answers.value)/Double(questions)*100
    }
    
}

