//
//  QuestionView.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 11/04/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    var question: Question?
    var label: UILabel?
    var button0: UIButton?
    var button1: UIButton?
    var button2: UIButton?
    var button3: UIButton?
    let buttonColor: UIColor = UIColor(red:0.78, green:0.80, blue:0.82, alpha:1.0)
    
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
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if let question = self.question{
            if(question.correctAnswer == sender.tag){
                sender.backgroundColor = UIColor.green
            }
            else{
                sender.backgroundColor = UIColor.red
            }
        }
        
    }
    
    
    
    // Ovaj init se poziva kada se CustomView inicijalizira iz .xib datoteke
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
