//
//  AddQuestionVC.swift
//  Millioner
//
//  Created by Станислав Буйновский on 08.06.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class AddQuestionVC: UIViewController {

    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answer1TextField: UITextField!
    @IBOutlet weak var answer1Switch: UISwitch!
    @IBOutlet weak var answer2TextField: UITextField!
    @IBOutlet weak var answer2Switch: UISwitch!
    @IBOutlet weak var answer3TextField: UITextField!
    @IBOutlet weak var answer3Switch: UISwitch!
    @IBOutlet weak var answer4TextField: UITextField!
    @IBOutlet weak var answer4Switch: UISwitch!
    @IBOutlet weak var addQuestionButton: UIButton!
    @IBOutlet weak var topMessageTextLabel: UILabel!
    
    private let questionsCaretacker: QuestionsCaretaker = .init()
    
    private var questions: [Question] = []
   
    private var alertText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topMessageTextLabel.text = "Fill new question fields!"
        topMessageTextLabel.textColor = .black
    }

    @IBAction func addQuestionButtonTaped(_ sender: Any) {
        
        let question: Question = .init()
        var answer: Answer = .init()
        
        if !questionTextField.text!.isEmpty {
            question.questionText = questionTextField.text!
        } else {
            alertText += "Question text is empty!\n"
        }
        
        
        if !answer1TextField.text!.isEmpty {
            answer = Answer()
            
            answer.answerText = answer1TextField.text!
            
            if answer1Switch.isOn {
                answer.isRightAnswer = true
            }
            
            question.answers.append(answer)
            
        } else {
            alertText += "Answer 1 text is empty!\n"
        }
        
        
        if !answer2TextField.text!.isEmpty {
            answer = Answer()
            
            answer.answerText = answer2TextField.text!
            
            if answer2Switch.isOn {
                answer.isRightAnswer = true
            }
            
            question.answers.append(answer)
            
        } else {
            alertText += "Answer 2 text is empty!\n"
        }
        
        
        if !answer3TextField.text!.isEmpty {
            answer = Answer()
            
            answer.answerText = answer3TextField.text!
            
            if answer3Switch.isOn {
                answer.isRightAnswer = true
            }
            
            question.answers.append(answer)
            
        } else {
            alertText += "Answer 3 text is empty!\n"
        }
        
        
        if !answer4TextField.text!.isEmpty {
            answer = Answer()
            
            answer.answerText = answer4TextField.text!
            
            if answer4Switch.isOn {
                answer.isRightAnswer = true
            }
            
            question.answers.append(answer)
            
        } else {
            alertText += "Answer 4 text is empty!\n"
        }
        
        
        let alert = UIAlertController(title: "Empty fields in form", message: alertText, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Fix", style: UIAlertAction.Style.default, handler: nil))
        
        
        if !alertText.isEmpty {
            self.present(alert, animated: true, completion: nil)
            alertText = ""
        } else {
            questions.append(question)
            questionsCaretacker.save(questions: questions)
            topMessageTextLabel.text = "Your question added to base!"
            topMessageTextLabel.textColor = .systemGreen
        }
        
        
        
        
        
    }
    
}
