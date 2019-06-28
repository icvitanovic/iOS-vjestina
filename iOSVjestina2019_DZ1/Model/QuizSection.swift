//
//  QuizSection.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 24/06/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation

struct QuizSection : Comparable {
    static func < (lhs: QuizSection, rhs: QuizSection) -> Bool {
        return lhs.category < rhs.category
    }
    
    static func == (lhs: QuizSection, rhs: QuizSection) -> Bool {
        return lhs.category == rhs.category
    }
    
    
    var category : String
    var quizzes : [Quiz]
    
    init(category: String, quizzes: [Quiz]) {
        self.category = category
        self.quizzes = quizzes
    }
    
}
