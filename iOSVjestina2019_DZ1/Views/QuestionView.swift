//
//  QuestionView.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 11/04/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit

protocol AnswerDelegate: AnyObject{
    func onAnswer(sender: UIButton, isCorrect: Bool)
}

class QuestionView: UIView {
    var question: Question?
    var label: UILabel?
    var button0: UIButton?
    var button1: UIButton?
    var button2: UIButton?
    var button3: UIButton?
    let buttonColor: UIColor = UIColor(red:0.78, green:0.80, blue:0.82, alpha:1.0)
    
    weak var delegate: AnswerDelegate?
    
    init(question: Question, frame: CGRect){
        self.question = question
        super.init(frame: frame)
        if let question = self.question{
            label = UILabel(frame: CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: frame.width - 20, height: 40)))
            let buttonWidth = frame.width / 2 - 20
            button0 = UIButton(frame: CGRect(x: 10, y: 50, width: buttonWidth, height: 40))
            button1 = UIButton(frame: CGRect(x: buttonWidth + 20, y: 50, width: buttonWidth, height: 40))
            button2 = UIButton(frame: CGRect(x: 10, y: 100, width: buttonWidth, height: 40))
            button3 = UIButton(frame: CGRect(x: buttonWidth + 20, y: 100, width: buttonWidth, height: 40))
            if let label = label {
                label.text = question.question
                label.textColor = UIColor.white
                label.numberOfLines = 3
                label.lineBreakMode = .byWordWrapping
                label.sizeToFit()
                self.addSubview(label)
            }
            if let button0 = button0{
                button0.backgroundColor = buttonColor
                button0.setTitleColor(UIColor.black, for: .normal)
                button0.setTitleColor(UIColor(red:0.51, green:0.51, blue:0.52, alpha:1.0), for: .highlighted)
                button0.setTitle(question.answers[0], for: .normal)
                button0.tag = 0
                button0.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                self.addSubview(button0)
            }
            if let button1 = button1{
                button1.backgroundColor = buttonColor
                button1.setTitleColor(UIColor.black, for: .normal)
                button1.setTitleColor(UIColor(red:0.51, green:0.51, blue:0.52, alpha:1.0), for: .highlighted)
                button1.setTitle(question.answers[1], for: .normal)
                button1.tag = 1
                button1.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                
                self.addSubview(button1)
            }
            if let button2 = button2{
                button2.backgroundColor = buttonColor
                button2.setTitleColor(UIColor.black, for: .normal)
                button2.setTitleColor(UIColor(red:0.51, green:0.51, blue:0.52, alpha:1.0), for: .highlighted)
                button2.setTitle(question.answers[2], for: .normal)
                button2.tag = 2
                button2.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                
                self.addSubview(button2)
            }
            if let button3 = button3{
                button3.backgroundColor = buttonColor
                button3.setTitleColor(UIColor.black, for: .normal)
                button3.setTitleColor(UIColor(red:0.51, green:0.51, blue:0.52, alpha:1.0), for: .highlighted)
                button3.setTitle(question.answers[3], for: .normal)
                button3.tag = 3
                button3.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                
                self.addSubview(button3)
            }
//            self.addConstraints()
        }
    }
    
    func addConstraints(){
        if let button0 = self.button0{
            button0.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint0 = NSLayoutConstraint(item: button0, attribute: .top, relatedBy: .equal, toItem: self.label, attribute: .bottom, multiplier: 1, constant: 10)
            let heightConstraint0 = NSLayoutConstraint(item: button0, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
            let leftConstraint0 = NSLayoutConstraint(item: button0, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10)
            let rightConstraint0 = NSLayoutConstraint(item: button0, attribute: .trailing, relatedBy: .equal, toItem: self.button1, attribute: .leading, multiplier: 1, constant: 20)
            self.addConstraints([topConstraint0, heightConstraint0, leftConstraint0, rightConstraint0])
        }
        
        if let button1 = self.button1{
            button1.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint1 = NSLayoutConstraint(item: button1, attribute: .top, relatedBy: .equal, toItem: self.label, attribute: .bottom, multiplier: 1, constant: 10)
            let heightConstraint1 = NSLayoutConstraint(item: button1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
            let leftConstraint1 = NSLayoutConstraint(item: button1, attribute: .leading, relatedBy: .equal, toItem: self.button0, attribute: .trailing, multiplier: 1, constant: 10)
            let rightConstraint1 = NSLayoutConstraint(item: button1, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 20)
            self.addConstraints([topConstraint1, heightConstraint1, leftConstraint1, rightConstraint1])
        }
        if let button2 = self.button2{
            button2.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint2 = NSLayoutConstraint(item: button2, attribute: .top, relatedBy: .equal, toItem: self.button0, attribute: .bottom, multiplier: 1, constant: 10)
            let heightConstraint2 = NSLayoutConstraint(item: button2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
            let leftConstraint2 = NSLayoutConstraint(item: button2, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10)
            let rightConstraint2 = NSLayoutConstraint(item: button2, attribute: .trailing, relatedBy: .equal, toItem: button3, attribute: .trailing, multiplier: 1, constant: 20)
            self.addConstraints([topConstraint2, heightConstraint2, leftConstraint2, rightConstraint2])
        }
        if let button3 = self.button3{
            button3.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint3 = NSLayoutConstraint(item: button3, attribute: .top, relatedBy: .equal, toItem: self.button1, attribute: .bottom, multiplier: 1, constant: 10)
            let heightConstraint3 = NSLayoutConstraint(item: button3, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
            let leftConstraint3 = NSLayoutConstraint(item: button3, attribute: .leading, relatedBy: .equal, toItem: self.button2, attribute: .leading, multiplier: 1, constant: 10)
            let rightConstraint3 = NSLayoutConstraint(item: button3, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 20)
            self.addConstraints([topConstraint3, heightConstraint3, leftConstraint3, rightConstraint3])
        }
        
        self.layoutIfNeeded()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if let question = self.question{
            let isCorrectAnswer: Bool = question.correctAnswer == sender.tag
            if(isCorrectAnswer){
                sender.backgroundColor = UIColor.green
            }
            else{
                sender.backgroundColor = UIColor.red
            }
            delegate?.onAnswer(sender: sender, isCorrect: isCorrectAnswer)
        }
        
    }
    
    // Ovaj init se poziva kada se CustomView inicijalizira iz .xib datoteke
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
