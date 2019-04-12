//
//  InitialViewController.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 11/04/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    @IBOutlet weak var funFactLabel: UILabel!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var quizNameLabel: UILabel!
    
    var quizzes: Array<Quiz> = []
    var quizService: QuizService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        quizService = QuizService()
    }

    @IBAction func fetchButtonTapped(_ sender: UIButton) {
        self.quizService.fetchQuizzes(){ (quizzes) in
            if let quizzes = quizzes{
                self.quizzes = quizzes
                if let quiz = quizzes.first{
                    self.showQuiz(quiz: quiz)
                }
                self.showFunFact(quizzArray: quizzes, lookUpString: "NBA")
            }
        }
    }
    
    func showFunFact(quizzArray: Array<Quiz>, lookUpString: String){
        var count: Int = 0
        let questionsPerQuiz = quizzArray.map({
            (quiz: Quiz) -> Int in
            let questonsWithString = quiz.questions.filter{(question) -> Bool in
                return question.question.contains(lookUpString)
            }
            return questonsWithString.count
        })
        for numberOfQuestions in questionsPerQuiz{
            count += numberOfQuestions
        }
        DispatchQueue.main.async {
            self.funFactLabel.isHidden = false
            self.funFactLabel.text = "Fun fact: \(count) questions containing '\(lookUpString)'"
        }
    }
    
    func showQuiz(quiz: Quiz){
        self.quizService.getQuizImage(quiz: quiz) { (image) in
            if(image == nil){
                print("image is nil")
            }
            DispatchQueue.main.async {
                self.quizImageView.image = image
                self.quizImageView.backgroundColor = QuizCategoryColor(rawValue: quiz.category)?.value
            }
        }
        DispatchQueue.main.async {
            self.quizNameLabel.text = quiz.title
            self.quizNameLabel.backgroundColor = QuizCategoryColor(rawValue: quiz.category)?.value
            if let firstQuestion = quiz.questions.first{
                let questionView = QuestionView(question: firstQuestion, frame: CGRect(x: 10, y: 200, width: self.view.frame.width - 20, height: 60))
                questionView.isUserInteractionEnabled = true
                questionView.translatesAutoresizingMaskIntoConstraints = false
                let topConstraint = NSLayoutConstraint(item: questionView, attribute: .top, relatedBy: .equal, toItem: self.quizImageView, attribute: .bottom, multiplier: 1, constant: 15)
                let bottomConstraint = NSLayoutConstraint(item: questionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 10)
                let leftConstraint = NSLayoutConstraint(item: questionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
                let rightConstraint = NSLayoutConstraint(item: questionView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 20)
                self.view.addSubview(questionView)
                self.view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
