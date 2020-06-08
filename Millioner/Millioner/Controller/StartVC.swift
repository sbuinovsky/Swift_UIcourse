//
//  ViewController.swift
//  Millioner
//
//  Created by Станислав Буйновский on 02.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit


class StartVC: UIViewController {
    
    weak var delegate: GameTVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Game.shared.loadResults()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewGameSeague" {
            
            Game.shared.prepareQuestions()
            
            guard let gameTVC = segue.destination as? GameTVC else { return }
            gameTVC.delegate = self
            
            Game.shared.gameSession = .init()
            
        }
    }

}

extension StartVC: GameTVCDelegate {
    func updateSession(totalQuestions: Int, rightAnswers: Int, totalBalance: Int) {
        Game.shared.gameSession?.questions = totalQuestions
        Game.shared.gameSession?.answers = rightAnswers
        Game.shared.gameSession?.balance = totalBalance
        Game.shared.addResult()

        print(#function)
    }
}
