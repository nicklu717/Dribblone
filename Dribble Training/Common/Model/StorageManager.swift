//
//  StorageManager.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/5.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import CoreData

class StorageManager {
    
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
}
