//
//  DataController.swift
//  VirtualTouristApp
//
//  Created by Khalid Aqeeli on 23/08/2020.
//  Copyright © 2020 Khalid Aqeeli. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    var backgroundContext: NSManagedObjectContext!
    
    init(modelName:String) {
        self.persistentContainer = NSPersistentContainer(name: modelName)
        
    }
    
    func configerContexts() {
        backgroundContext = persistentContainer.newBackgroundContext()
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            self.configerContexts()
        completion?()
        }
    }
    
}

// autosave
extension DataController {
    // 30 is the default value xs
    func autoSaveViewContext(interval:TimeInterval = 30) {
        guard interval > 0 else { print("cannot set a nagitve number")
            return }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
