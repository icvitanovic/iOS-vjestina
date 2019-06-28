//
//  Quiz.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 11/04/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation
import UIKit

struct QuizzesDict: Codable{
    let quizzes: Array<Quiz>
}

struct Quiz: Codable{
    let id: Int
    let title: String
    let description: String
    let category: String
    let level: Int
    let imageUrl: String
    let questions: Array<Question>
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case level
        case imageUrl = "image"
        case questions
    }
    
//    init(from decoder: Decoder) throws{
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//    }
}
