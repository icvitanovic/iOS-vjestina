//
//  LeaderboardItem.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 27/06/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation

struct LeaderBoardItem: Codable{
    let username: String
    let score: String
    
    private enum CodingKeys: String, CodingKey {
        case username
        case score
    }
}
