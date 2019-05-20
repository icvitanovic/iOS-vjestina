//
//  QuizService.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 11/04/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation
import UIKit

class QuizService{
    private let urlString = "https://iosquiz.herokuapp.com/api/quizzes"
    func fetchQuizzes(completion: @escaping ((Array<Quiz>?) -> Void)){
        if let url = URL(string: urlString){
            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request){ (data, response, error) in
                if let data = data{
                    let decoder = JSONDecoder()
                    do{
                        let quizzesDict = try decoder.decode(QuizzesDict.self, from: data)
                        print(quizzesDict)
                        completion(quizzesDict.quizzes)
                    }
                    catch{
                        print(error.localizedDescription)
                        completion(nil)
                    }
                }
                else{
                    completion(nil)
                }
            }
            dataTask.resume()
        }
        else{
            completion(nil)
        }
    }
    
    func getQuizImage(quiz: Quiz, completion: @escaping ((UIImage?) -> Void)){
        if let url = URL(string: quiz.imageUrl){
            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image)
                } else {
                    completion(nil)
                }
            }
            dataTask.resume()
        } else {
            completion(nil)
        }
    }
}
