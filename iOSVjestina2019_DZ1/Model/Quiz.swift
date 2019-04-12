//
//  Quiz.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 11/04/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation
import UIKit

class Quiz{
    let id: Int
    let title: String
    let description: String
    let category: String
    let level: Int
    let imageUrl: String
    let questions: Array<Question>
    
    init?(json: Any) {
        if let jsonDict = json as? [String: Any],
            let id = jsonDict["id"] as? Int,
            let title = jsonDict["title"] as? String,
            let description = jsonDict["description"] as? String,
            let category = jsonDict["category"] as? String,
            let level = jsonDict["level"] as? Int,
            let imageUrl = jsonDict["image"] as? String,
            let questionsJson = jsonDict["questions"] as? [[String: Any]]{
            self.id = id
            self.title = title
            self.description = description
            self.category = category
            self.level = level
            self.imageUrl = imageUrl
            var questions: Array<Question> = []
            for questionJson in questionsJson{
                if let question = Question(json: questionJson){
                    questions.append(question)
                }
            }
            self.questions = questions
        }else{
            return nil
        }
    }
}
