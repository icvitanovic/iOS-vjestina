//
//  AuthService.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 20/05/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation

class AuthService{
    private let urlString = "https://iosquiz.herokuapp.com/api/session"
    func login(username: String, password: String, completion: @escaping ((AuthToken?) -> Void)){
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let loginParameters: LoginParameters = LoginParameters(username: username, password: password)
            do{
                let encoder = JSONEncoder()
                let loginParametersJson = try encoder.encode(loginParameters)
                request.httpBody = loginParametersJson
                
                let dataTask = URLSession.shared.dataTask(with: request){ (data, response, error) in
                    if let data = data{
                        let decoder = JSONDecoder()
                        do{
                            let authToken = try decoder.decode(AuthToken.self, from: data)
                            print(authToken)
                            completion(authToken)
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
            catch{
                completion(nil)
            }
        }
        else{
            completion(nil)
        }
    }
}
