//
//  Question2+CoreDataClass.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 27/06/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation
import CoreData

@objc(Question2)
public class Question2: NSManagedObject {
    
    class func firstOrCreate(fromQuestion question: Question) -> Question2? {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<Question2> = Question2.fetchRequest()
        request.predicate = NSPredicate(format: "id = %ld", question.id)
        request.returnsObjectsAsFaults = false
        
        do {
            let questions = try context.fetch(request)
            if let question = questions.first {
                return question
            } else {
                let newQuestion = Question2(context: context)
                return newQuestion
            }
        } catch {
            return nil
        }
    }
    
    class func createFrom(_question: Question) -> Question2? {
        if let question = Question2.firstOrCreate(fromQuestion: _question) {
            question.question = _question.question
            question.answers = _question.answers as NSObject
            question.correctAnswer = Int32(_question.correctAnswer)
            do {
                let context = DataController.shared.persistentContainer.viewContext
                try context.save()
                return question
            } catch {
                print("Failed saving")
            }
        }
        return nil
    }
    
}
