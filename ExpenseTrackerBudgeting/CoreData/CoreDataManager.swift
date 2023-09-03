//
//  CoreDataManager.swift
//  ExpenseTrackerBudgeting
//
//  Created by Kevin Sander Utomo on 09/05/23.
//

import Foundation
import CoreData

class CoreDataManager {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "TransactionModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading Core Data stack: \(error)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
