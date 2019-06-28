//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 20/05/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class QuizViewController: UIViewController, AnswerDelegate {
    @IBOutlet weak var quizNameLabel: UILabel!
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var startQuizButton: UIButton!
    @IBOutlet weak var leaderBoardButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var quiz: Quiz2? = nil
    var currentQuestion: Int = 1
    var correctAnswers: Int = 0
    var startTime: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
        quizNameLabel.text = quiz?.title
        quizNameLabel.textColor = UIColor.white
        if let urlString = quiz?.imageUrl {
            self.quizImage.kf.setImage(with: URL(string: urlString))
        }
        quizNameLabel.snp.makeConstraints({(make) -> Void in
            make.centerX.equalTo(self.view)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).inset(20)
        })
        quizImage.snp.makeConstraints({(make) -> Void in
            make.top.equalTo(quizNameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(self.view)
            make.width.height.equalTo(200)
        })
        quizImage.layer.cornerRadius = 5
        leaderBoardButton.snp.makeConstraints({(make) -> Void in
            make.top.equalTo(quizImage.snp.bottom).offset(5)
            make.centerX.equalTo(self.view)
            make.width.equalTo(200)
        })
        startQuizButton.snp.makeConstraints({(make) -> Void in
            make.top.equalTo(leaderBoardButton.snp.bottom).offset(5)
            make.centerX.equalTo(self.view)
            make.width.equalTo(100)
            make.height.equalTo(50)
        })
        startQuizButton.alpha = 1
        startQuizButton.backgroundColor = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
        startQuizButton.setTitleColor(UIColor.white, for: .normal)
        startQuizButton.layer.cornerRadius = startQuizButton.frame.height / 3
        leaderBoardButton.setTitleColor(UIColor.white, for: .normal)
        scrollView.snp.makeConstraints({(make) -> Void in
            make.top.equalTo(startQuizButton.snp.bottom).offset(10)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view).inset(20)
        })
        scrollView.transform = CGAffineTransform(translationX: 0, y: scrollView.frame.origin.y)
        scrollView.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        addQuestions()
    }
    
    func addQuestions(){
        if let quiz = quiz{
            if let questions = quiz.questions{
                scrollView.contentSize = CGSize(width: CGFloat(questions.count) * CGFloat(scrollView.frame.width), height: CGFloat(scrollView.frame.height))
                scrollView.isPagingEnabled = true
                scrollView.isScrollEnabled = false
                self.currentQuestion = 1
                for i in 0 ..< questions.count{
                    let question = questions.allObjects[i]
                    let questionView = QuestionView(question: question as! Question2, frame: CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
                    questionView.delegate = self
                    scrollView.addSubview(questionView)
                }
            }
        }
    }
    
    @IBAction func leaderboardTap(_ sender: Any) {
        if let quiz = self.quiz{
            navigationController?.pushViewController(LeaderboardViewController(quizId: quiz.id), animated: true)
        }
    }
    
    @IBAction func startQuizTap(_ sender: Any) {
//        startQuizButton.isHidden = true
        UIView.animate(withDuration: 0.35, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.startQuizButton.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.startQuizButton.alpha = 0
            self.scrollView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.scrollView.alpha = 1
        }, completion: {(finished:Bool) in
            self.startTime = Date()
        })
    }
    
    func onAnswer(sender: UIButton, isCorrect: Bool) {
        if let quiz = quiz{
            if(isCorrect == true){
                self.correctAnswers += 1
            }
            if(self.currentQuestion < quiz.questions!.count){
                scrollView.setContentOffset(CGPoint(x: CGFloat(CGFloat(currentQuestion) * scrollView.frame.width), y: 0), animated: true)
                self.currentQuestion = self.currentQuestion + 1
            }
            else{
                // last question
                let time = Date().timeIntervalSince(startTime)
                if let userId = AuthService().getUserId(){
                    let quizResult = QuizResult(quizId: Int(quiz.id), userId: userId, time: time, numberOfCorrectAnswers: self.correctAnswers)
                    self.submitResults(quizResult: quizResult)
                }
                else{
                    print("Could not find user id!")
                }
            }
        }
    }
    
    func submitResults(quizResult: QuizResult){
        QuizService().submitQuizResult(quizResult: quizResult){ [weak self] (statusCode) in
            if let status = statusCode{
                switch status{
                case .ok:
                    self?.returnToQuizzes()
                case .unauthorized:
                    let alert = UIAlertController(title: "Error", message: "Authorization failed. Try logging in again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Back to login", style: .default, handler: {(_: UIAlertAction!) in
                        DispatchQueue.main.async {
                            AuthService().logout()
                            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                            appDelegate.showLogin()
                        }
                    }))
                    self?.present(alert, animated: true)
                case .badrequest:
                    let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: {(_: UIAlertAction!) in
                        self?.submitResults(quizResult: quizResult)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(_: UIAlertAction!) in
                        self?.returnToQuizzes()
                    }))
                    self?.present(alert, animated: true)
                case .notfound:
                    let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: {(_: UIAlertAction!) in
                        self?.submitResults(quizResult: quizResult)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(_: UIAlertAction!) in
                        self?.returnToQuizzes()
                    }))
                    self?.present(alert, animated: true)
                case .forbidden:
                    let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: {(_: UIAlertAction!) in
                        self?.submitResults(quizResult: quizResult)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(_: UIAlertAction!) in
                        self?.returnToQuizzes()
                    }))
                    self?.present(alert, animated: true)
                case .unrecognized:
                    let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: {(_: UIAlertAction!) in
                        self?.submitResults(quizResult: quizResult)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(_: UIAlertAction!) in
                        self?.returnToQuizzes()
                    }))
                    self?.present(alert, animated: true)
                    //                            default:
                    //                                let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                    //                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
                    //                                    self?.returnToQuizzes()
                    //                                }))
                    //                                self?.present(alert, animated: true)
                }
            }
            else{
                
            }
        }
    }
    
    func returnToQuizzes(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.35, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.scrollView.transform = CGAffineTransform(translationX: 0, y: self.scrollView.frame.origin.y)
                self.scrollView.alpha = 0
            }, completion: {(finished:Bool) in
                self.navigationController?.popViewController(animated: true);
            })
            
        }
    }


}
