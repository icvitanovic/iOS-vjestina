//
//  QuizCategory.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 11/04/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation
import UIKit

enum QuizCategoryColor: String{
    case sports = "SPORTS"
    case science = "SCIENCE"
}

extension QuizCategoryColor{
    var value: UIColor{
        get {
            switch self{
            case .sports:
                return UIColor(red:1.00, green:0.58, blue:0.19, alpha:1.0)
            
            case .science:
                return UIColor(red:0.58, green:0.73, blue:0.98, alpha:1.0)
            }
            
        }
    }
}
