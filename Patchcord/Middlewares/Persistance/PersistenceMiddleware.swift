//
//  PersistenceMiddleware.swift
//  Patchcord
//
//  Created by Maksym Bilan on 15.06.2022.
//

import CoreData
import Combine

struct PersistenceMiddleware {
    static let shared = PersistenceMiddleware()

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

    func middleware(state: SceneState, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case ConnectionStateAction.saveResults(let result):
            save(result)
            break
        default:
            break
        }
        return Empty().eraseToAnyPublisher()
    }
}

fileprivate extension PersistenceMiddleware {

    func save(_ result: ConnectionTestResult) {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.perform {
            let test = Test(context: backgroundContext)
            test.downloadResult = result.downloadSpeed
            test.uploadResult = result.uploadSpeed
            test.timestamp = Date()

            do {
                try backgroundContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}
