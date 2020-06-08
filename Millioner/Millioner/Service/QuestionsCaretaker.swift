//
//  QuestionsCaretaker.swift
//  Millioner
//
//  Created by Станислав Буйновский on 08.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

final class QuestionsCaretaker {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let key = "records"
    
    func save(questions: [Question]) {
        do {
            let data = try self.encoder.encode(questions)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func retrieveRecords() -> [Question] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        do {
            return try self.decoder.decode([Question].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
}
