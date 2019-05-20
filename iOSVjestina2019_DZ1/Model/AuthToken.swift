//
//  AuthToken.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 20/05/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation

struct AuthToken: Codable{
    let token: String
    let userId: Int
    
    private enum CodingKeys: String, CodingKey {
        case token
        case userId = "user_id"
    }
}
