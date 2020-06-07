//
//  Game.swift
//  Millioner
//
//  Created by Станислав Буйновский on 03.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

final class Game {
    
    private let realmService: RealmServiceProtocol = RealmService()
    
    static let shared = Game()
    
    var gameSession: GameSession?
    
    var results = [Result]()
    
    private var questions = [Question]()
    private var gameQuestions = [Question]()
    
    private init() { }
    
    private func createQuestions() {
        
        for i in 0...9 {
            
            let question = Question()
            
            question.id = i
            question.questionText = "Question number: \(i+1)"
            
            for j in 0...3 {
                let answer = Answer()
                answer.answerText = "Answer number \(j+1)"
                
                if j == 2 {
                    answer.isRightAnswer = true
                }
                
                question.answers.append(answer)
            }
            
            question.cost = i * 1000 + 1000
            questions.append(question)
            
        }
        
    }
    
    
    func prepareQuestions() {
        createQuestions()
        gameQuestions = questions
    }
    
    
    func getQuestion() -> Question? {
        
        if !gameQuestions.isEmpty {
            
            let question = gameQuestions.first
            gameQuestions.removeFirst()
            
            return question
            
        } else {
            print("Empty questions array")
            
            return nil
        }
    }
    
    
    func addResult() {
        let result = Result()
        
        if let id = results.last?.id {
            result.id = id + 1
        }
        
        if gameSession != nil {
            result.balance = gameSession!.balance
            let questions = Double(gameSession!.questions)
            let answers = Double(gameSession!.answers)
            result.percentage = answers/questions * 100
        }
        
        results.append(result)
        
        do {
            try realmService.saveResults(results: results)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    func loadResults() {
        results = realmService.getResults()
    }
    
    func getResults() -> [Result] {
        return results
    }
}


