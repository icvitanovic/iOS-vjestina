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
    @IBOutlet weak var scrollView: UIScrollView!
    
    var quiz: Quiz? = nil
    var currentQuestion: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.16, green:0.50, blue:0.73, alpha:1.0)
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
        startQuizButton.snp.makeConstraints({(make) -> Void in
            make.top.equalTo(quizImage.snp.bottom).offset(10)
            make.centerX.equalTo(self.view)
            make.width.equalTo(100)
            make.height.equalTo(50)
        })
        startQuizButton.backgroundColor = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
        startQuizButton.setTitleColor(UIColor.white, for: .normal)
        scrollView.snp.makeConstraints({(make) -> Void in
            make.top.equalTo(startQuizButton.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).inset(20)
            make.bottom.equalTo(self.view).inset(20)
        })
        addQuestions()
    }
    
    func addQuestions(){
        if let quiz = quiz{
            scrollView.contentSize = CGSize(width: CGFloat(quiz.questions.count) * CGFloat(scrollView.frame.width), height: CGFloat(scrollView.frame.height))
            scrollView.isPagingEnabled = true
            scrollView.isScrollEnabled = false
            currentQuestion = 1
            for i in 0 ..< quiz.questions.count{
                let question = quiz.questions[i]
                let questionView = QuestionView(question: question, frame: CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
                questionView.delegate = self
                scrollView.addSubview(questionView)
            }
        }
    }
    
    func onAnswer(sender: UIButton, isCorrect: Bool) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(CGFloat(currentQuestion) * scrollView.frame.width), y: 0), animated: true)
        currentQuestion = currentQuestion + 1
    }


}
