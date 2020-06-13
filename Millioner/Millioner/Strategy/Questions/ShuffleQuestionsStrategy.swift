//
//  ShuffleQuestionsStrategy.swift
//  Millioner
//
//  Created by Станислав Буйновский on 08.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import Foundation

final class ShuffleQuestionsStrategy: QuestionsStrategy {
    func getQuestion() -> Question? {
        return Game.shared.getShuffleQuestion()
    }
    
}
