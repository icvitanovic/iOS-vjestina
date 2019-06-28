//
//  QuizService.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 11/04/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class QuizService{
    private let urlString = "https://iosquiz.herokuapp.com/api/quizzes"
    private let resultUrlString = "https://iosquiz.herokuapp.com/api/result"
    private let leaderboardUrlString = "​https://iosquiz.herokuapp.com/api/score"
    func fetchQuizzes(completion: @escaping ((Bool) -> Void)){
        if let url = URL(string: urlString){
            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request){ (data, response, error) in
                if let data = data{
                    let decoder = JSONDecoder()
                    do{
                        let quizzesDict = try decoder.decode(QuizzesDict.self, from: data)
                        for _quiz in quizzesDict.quizzes{
                            let quiz = Quiz2.createFrom(_quiz: _quiz)
                        }
                        completion(true)
                    }
                    catch{
                        print(error.localizedDescription)
                        completion(false)
                    }
                }
                else{
                    completion(false)
                }
            }
            dataTask.resume()
        }
        else{
            completion(false)
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
    
    func submitQuizResult(quizResult: QuizResult, completion: @escaping ((StatusCode?) -> Void)){
        if let authToken = AuthService().getLoginToken(){
            if let url = URL(string: resultUrlString){
                let session = URLSession.shared
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                do {
                    let encoder = JSONEncoder()
                    let jsonData = try encoder.encode(quizResult)
                    request.httpBody = jsonData
                } catch let error {
                    print(error.localizedDescription)
                }
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue(authToken, forHTTPHeaderField: "Authorization")
                
                //create dataTask using the session object to send data to the server
                let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        print(httpResponse.statusCode)
                        if let statusCode = StatusCode(rawValue: httpResponse.statusCode){
                            completion(statusCode)
                        }
                        else{
                            completion(StatusCode.unrecognized)
                        }
                    }
                    else{
                        completion(StatusCode.badrequest)
                    }
                })
                task.resume()
            }
        }
        else{
            print("Could not find auth token!")
            completion(StatusCode.badrequest)
        }
    }
    
    func fetchLeaderboard(quizId: Int, completion: @escaping ((Array<LeaderBoardItem>?) -> Void)){
        if let authToken = AuthService().getLoginToken(){
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "iosquiz.herokuapp.com"
            urlComponents.path = "/api/score"
            urlComponents.queryItems = [
                URLQueryItem(name: "quiz_id", value: String(quizId))
            ]
            if let url = urlComponents.url{
                var request = URLRequest(url: url)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue(authToken, forHTTPHeaderField: "Authorization")
                let dataTask = URLSession.shared.dataTask(with: request){ (data, response, error) in
                    if let data = data{
                        let decoder = JSONDecoder()
                        do{
                            let scores = try decoder.decode([LeaderBoardItem].self, from: data)
                            completion(scores)
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
        
    }
}
