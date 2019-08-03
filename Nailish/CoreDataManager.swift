//
//  CoreDataManager.swift
//  Naily
//
//  Created by Shota Iwamoto on 2019-06-07.
//  Copyright © 2019 Shota Iwamoto. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    private init(){}
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ClientModel")
        
        container.loadPersistentStores {(storeDiscription, error) in
            if let err = error {
                fatalError("Loading of persistent store failed: \(err)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let saveError {
                fatalError("failed to delete  a company: \(saveError)")
            }
        }
    }
    
}
