//
//  StatusCode.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 25/06/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation

enum StatusCode: Int{
    case unauthorized = 401
    case forbidden = 403
    case notfound = 404
    case badrequest = 400
    case ok = 200
    case unrecognized
}
