//
//  Login.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 20/05/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation

struct LoginParameters: Codable{
    var username: String
    var password: String
    
    private enum CodingKeys: String, CodingKey {
        case username
        case password
    }
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
