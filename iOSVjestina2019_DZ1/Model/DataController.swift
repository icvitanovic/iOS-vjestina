//
//  DataController.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 27/06/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static let shared = DataController()
    private init() {} // Prevent clients from creating another instance.
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getQuizzesResultController() -> NSFetchedResultsController<Quiz2>? {
        let request: NSFetchRequest<Quiz2> = Quiz2.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
        let context = DataController.shared.persistentContainer.viewContext
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "category", cacheName: nil)
        
        do {
            try controller.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        return controller
    }
    
    func getQuizzesResultController(withFilter searchTerm: String) -> NSFetchedResultsController<Quiz2>? {
        let request: NSFetchRequest<Quiz2> = Quiz2.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
        request.predicate = NSPredicate(format: "title CONTAINS[c] %@ OR quizDescription CONTAINS[c] %@", searchTerm, searchTerm)
        let context = DataController.shared.persistentContainer.viewContext
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "category", cacheName: nil)
        
        do {
            try controller.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        return controller
    }
    
    
    func saveContext () {
        
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteObject(object: NSManagedObject){
        persistentContainer.viewContext.delete(object)
    }
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                persistentContainer.viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
}
