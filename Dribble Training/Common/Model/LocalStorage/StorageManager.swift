//
//  StorageManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/5.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import CoreData

class StorageManager {
    
    // MARK: - Property Declaration
    
    static let shared = StorageManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DribbleTraining")
        
        container.loadPersistentStores { (_, error) in
            
            if let error = error {
                fatalError("Unresolve Error: \(error), \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        
        return persistentContainer.viewContext
    }
    
    private enum Entity: String {
        
        case trainingResult = "TrainingResult"
    }
    
    var trainingResults: [TrainingResult] = []
    
    // MARK: - Instance Method
    
    func fetchTrainingResult() {
        
        let request = NSFetchRequest<TrainingResult>(entityName: Entity.trainingResult.rawValue)
        
//        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            trainingResults = try viewContext.fetch(request)
        } catch {
            print("Training Data Fetching Failure")
        }
    }
    
    func saveContext() {
        
        if viewContext.hasChanges {
            
            do {
                try viewContext.save()
            } catch {
                fatalError("Unresolve Error: \(error), \(error.localizedDescription)")
            }
        }
    }
}
