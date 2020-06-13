//
//  GameTVC.swift
//  Millioner
//
//  Created by Станислав Буйновский on 03.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

protocol GameTVCDelegate: class {
    func updateSession(totalBalance: Int)
}

class GameTVC: UITableViewController {
    
    private var question: Question?
    
    private var indexPathArray: [IndexPath] = []
    
    weak var delegate: GameTVCDelegate?
    
    private var rightAnswerTrigger: Bool = false
    var balance: Int = 0
    
    var questionsStrategy: QuestionsStrategy = Game.shared.getStrategy()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Game.shared.gameSession?.questions = Game.shared.getTotalQuestionsCount()
        
        question = questionsStrategy.getQuestion()
        
        self.tableView.separatorStyle = .none
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = getCell(indexPath: indexPath)
        
        if !indexPathArray.contains(indexPath) {
            indexPathArray.append(indexPath)
        }

        return cell
    }
    
    private func getCell(indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderGameTVCCell", for: indexPath) as! HeaderGameTVCCell
            
            if rightAnswerTrigger {
                cell.nextQuestionButton.isHidden = false
            } else {
                cell.nextQuestionButton.isHidden = true
            }
            
            return cell
        
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionGameTVCCell", for: indexPath) as! QuestionGameTVCCell
            
            cell.questionLabel.text = question?.questionText
            
            return cell
       
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FooterGameTVCCell", for: indexPath) as! FooterGameTVCCell
            
            Game.shared.gameSession?.answers.addObserver(self, options:[.new, .initial], closure: { (answers, _) in
                let progressTextLabel = "Answers: \(answers)   Progress: \(Game.shared.gameSession!.persentage.rounded())%"
                cell.gameProgress.text = progressTextLabel
            }
            )
            
            cell.costLabel.text = "Cost: \(question!.cost)"
            cell.balanceLabel.text = "Balance: \(balance)"
            
            if rightAnswerTrigger {
                cell.resultMessageLabel.text = "Right answer!"
                cell.resultMessageLabel.textColor = .systemGreen
                cell.resultMessageLabel.isHidden = false
            } else {
                cell.resultMessageLabel.isHidden = true
            }
           
            
            return cell
       
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerGameTVCCell", for: indexPath) as! AnswerGameTVCCell
            
            guard let answers = question?.answers else { return AnswerGameTVCCell() }
            let answer = answers[indexPath.row - 2]
            
            cell.indexPath = indexPath
            cell.answerLabel.textColor = .black
            cell.answerLabel.text = answer.answerText
            cell.rightAnswer = answer.isRightAnswer
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
            cell.contentView.addGestureRecognizer(tapGesture)
            
            return cell
        }
        
    }

    
    @objc func onTap(_ sender: UIGestureRecognizer) {
        
        let tapLocation = sender.location(in: self.tableView)
        
        if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
            
            let answerCell = self.tableView.cellForRow(at: tapIndexPath) as! AnswerGameTVCCell
            
            if answerCell.rightAnswer {
                
                Game.shared.gameSession?.answers.value += 1
                balance += question!.cost
                
                answerCell.answerLabel.textColor = .systemGreen
                rightAnswerTrigger = true
                tableView.reloadRows(at: [indexPathArray.first!,indexPathArray.last!], with: .automatic)
                
            } else {
                answerCell.answerLabel.textColor = .systemRed
                didEndGame()
            }
        }
        
        
    }
    
    @IBAction func nextQuestionButton(_ sender: Any) {
        question = questionsStrategy.getQuestion()
        
        if question != nil {
            rightAnswerTrigger = false
            tableView.reloadData()
        } else {
            didEndGame()
        }
        
    }
    
    @IBAction func endGameButton(_ sender: Any) {
        didEndGame()
    }
    
    private func didEndGame() {
        Game.shared.prepareQuestions()
        self.delegate?.updateSession(totalBalance: balance)
        self.dismiss(animated: true, completion: nil)
    }

}
