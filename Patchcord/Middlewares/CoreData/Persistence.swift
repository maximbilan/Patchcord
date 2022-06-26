//
//  PersistenceMiddleware.swift
//  Patchcord
//
//  Created by Maksym Bilan on 15.06.2022.
//

import Combine
import CoreData

/// Persistence - loads and sets up the Core Data storage (+ iCloud) 💿 ☁️
struct Persistence {
    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Patchcord")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                #if DEBUG
                fatalError("Unresolved error \(error), \(error.userInfo)")
                #endif
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

}
