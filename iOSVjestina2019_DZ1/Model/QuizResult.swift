//
//  QuizResult.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 25/06/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation

struct QuizResult: Codable{
    let quizId: Int
    let userId: Int
    let time: TimeInterval
    let numberOfCorrectAnswers: Int
    
    init(quizId: Int, userId: Int, time: TimeInterval, numberOfCorrectAnswers: Int){
        self.quizId = quizId
        self.userId = userId
        self.time = time
        self.numberOfCorrectAnswers = numberOfCorrectAnswers
    }
    
    private enum CodingKeys: String, CodingKey {
        case quizId = "quiz_id"
        case userId = "user_id"
        case time
        case numberOfCorrectAnswers = "no_of_correct"
    }
}
