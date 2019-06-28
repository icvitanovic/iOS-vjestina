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
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    @IBAction func fetchButtonTapped(_ sender: UIButton) {
//        self.quizService.fetchQuizzes(){ (quizzes) in
//            if let quizzes = quizzes{
//                self.quizzes = quizzes
//                let randomIndex = Int.random(in: 0 ... quizzes.count-1)
//                let quiz = quizzes[randomIndex]
//                self.showQuiz(quiz: quiz)
//                self.showFunFact(quizzArray: quizzes, lookUpString: "NBA")
//            }
//            else{
//                let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                self.present(alert, animated: true)
//            }
//        }
    }
    
    func showFunFact(quizzArray: Array<Quiz>, lookUpString: String){
        let lookUpCount = quizzArray.flatMap({$0.questions.map({$0.question}).filter({$0.contains(lookUpString)})}).count
        DispatchQueue.main.async {
            self.funFactLabel.isHidden = false
            self.funFactLabel.text = "Fun fact: \(lookUpCount) questions containing '\(lookUpString)'"
        }
    }
    
//    func showQuiz(quiz: Quiz){
//        DispatchQueue.main.async {
//            self.removeQuestionView()
//            self.quizImageView.backgroundColor = UIColor.clear
//            self.quizImageView.image = nil
//            self.quizNameLabel.text = ""
//            self.quizNameLabel.backgroundColor = UIColor.clear
//        }
//
//        self.quizService.getQuizImage(quiz: quiz) { (image) in
//            if(image == nil){
//                print("image is nil")
//            }
//            DispatchQueue.main.async {
//                self.quizImageView.image = image
//                self.quizImageView.backgroundColor = QuizCategoryColor(rawValue: quiz.category)?.value
//                self.quizNameLabel.text = quiz.title
//                self.quizNameLabel.backgroundColor = QuizCategoryColor(rawValue: quiz.category)?.value
//                if let firstQuestion = quiz.questions.first{
//                    self.addQuestionView(question: firstQuestion)
//                }
//            }
//        }
////        DispatchQueue.main.async {
////            self.quizNameLabel.text = quiz.title
////            self.quizNameLabel.backgroundColor = QuizCategoryColor(rawValue: quiz.category)?.value
////            self.removeQuestionView()
////            if let firstQuestion = quiz.questions.first{
////                self.addQuestionView(question: firstQuestion)
////            }
////        }
//
//    }
    
    func addQuestionView(question: Question2){
        let questionView = QuestionView(question: question, frame: CGRect(x: 10, y: 200, width: self.view.frame.width - 20, height: 60))
        questionView.isUserInteractionEnabled = true
        questionView.translatesAutoresizingMaskIntoConstraints = false
        // prouci pure layout
        let topConstraint = NSLayoutConstraint(item: questionView, attribute: .top, relatedBy: .equal, toItem: self.quizImageView, attribute: .bottom, multiplier: 1, constant: 15)
        let bottomConstraint = NSLayoutConstraint(item: questionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 10)
        let leftConstraint = NSLayoutConstraint(item: questionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
        let rightConstraint = NSLayoutConstraint(item: questionView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 20)
        self.view.addSubview(questionView)
        self.view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        self.view.layoutIfNeeded()
    }
    
    func removeQuestionView(){
        for view in self.view.subviews{
            if let questionView = view as? QuestionView{
                questionView.removeFromSuperview()
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
