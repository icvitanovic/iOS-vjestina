//
//  File.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 11/04/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation

struct Question: Codable{
    let id: Int
    let question: String
    let answers: [String]
    let correctAnswer: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case question
        case answers
        case correctAnswer = "correct_answer"
    }
}
