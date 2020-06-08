//
//  QuestionsStrategy.swift
//  Millioner
//
//  Created by Станислав Буйновский on 08.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import Foundation

protocol QuestionsStrategy {
    func getQuestion() -> Question?
}
