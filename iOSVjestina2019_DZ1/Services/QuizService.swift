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
    let urlString = "https://iosquiz.herokuapp.com/api/quizzes"
    func fetchQuizzes(completion: @escaping ((Array<Quiz>?) -> Void)){
        if let url = URL(string: urlString){
            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request){ (data, response, error) in
                if let data = data{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let quizzesJson = json as? [String: Any]{
                            if let quizzesArrayJson = quizzesJson["quizzes"] as? [[String: Any]]{
                                var quizzes: Array<Quiz> = []
                                for quizJson in quizzesArrayJson{
                                    if let quiz = Quiz(json: quizJson){
                                        quizzes.append(quiz)
                                    }
                                }
                                completion(quizzes)
                            }
                        }
                    }
                    catch{
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
