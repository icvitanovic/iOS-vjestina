//
//  Quiz2+CoreDataClass.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 27/06/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation
import CoreData

@objc(Quiz2)
public class Quiz2: NSManagedObject {
    
    class func firstOrCreate(fromQuiz quiz: Quiz) -> Quiz2? {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<Quiz2> = Quiz2.fetchRequest()
        request.predicate = NSPredicate(format: "id = %ld", quiz.id)
        request.returnsObjectsAsFaults = false
        
        do {
            let quizzes = try context.fetch(request)
            if let quiz = quizzes.first {
                return quiz
            } else {
                let newQuiz = Quiz2(context: context)
                return newQuiz
            }
        } catch {
            return nil
        }
    }
    
    class func createFrom(_quiz: Quiz) -> Quiz2? {
        if let quiz = Quiz2.firstOrCreate(fromQuiz: _quiz) {
            if let quizQuestions = quiz.questions{
                quiz.removeFromQuestions(quizQuestions)
//                for question in quizQuestions{
//                    guard let questionData = question as? NSManagedObject else {continue}
//                    DataController.shared.deleteObject(object: questionData)
//                }
            }
            for _question in _quiz.questions{
                if let question = Question2.createFrom(_question: _question){
                    if let quizQuestions = quiz.questions{
                        if(quizQuestions.contains(question)){
                            
                        }
                        else{
                            quiz.addToQuestions(question)
                        }
                    }
                    
//                    if(question.quiz == nil){
//                        let _questions = quiz.mutableSetValue(forKey: "questions")
//                        _questions.add(question)
//                    }
                }
            }
            quiz.id = Int32(_quiz.id)
            quiz.category = _quiz.category
            quiz.level = Int32(_quiz.level)
            quiz.imageUrl = _quiz.imageUrl
            quiz.quizDescription = _quiz.description
            quiz.title = _quiz.title
            do {
                let context = DataController.shared.persistentContainer.viewContext
                try context.save()
                return quiz
            } catch {
                print("Failed saving")
            }
        }
        return nil
    }
    
}
