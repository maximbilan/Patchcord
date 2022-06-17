//
//  CoreDataRepository.swift
//  Patchcord
//
//  Created by Maksym Bilan on 17.06.2022.
//

import CoreData
import Combine

enum RepositoryError: Error {
    case objectNotFound
    case noObjects
}

class CoreDataRepository<Entity: NSManagedObject>: ObservableObject {
    private let context: NSManagedObjectContext
    private let dispatchQueue: DispatchQueue

    init(context: NSManagedObjectContext, dispatchQueue: DispatchQueue = DispatchQueue.main) {
        self.context = context
        self.dispatchQueue = dispatchQueue
    }

    func fetch(sortDescriptors: [NSSortDescriptor] = [],
               predicate: NSPredicate? = nil) -> AnyPublisher<[Entity], Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    let request = Entity.fetchRequest()
                    request.sortDescriptors = sortDescriptors
                    request.predicate = predicate
                    do {
                        let results = try context.fetch(request) as? [Entity]
                        if let results = results {
                            promise(.success(results))
                        } else {
                            promise(.failure(RepositoryError.noObjects))
                        }
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: dispatchQueue)
        .eraseToAnyPublisher()
    }

    func add(_ body: @escaping (inout Entity) -> Void) -> AnyPublisher<Entity, Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    var entity = Entity(context: context)
                    body(&entity)
                    do {
                        try context.save()
                        promise(.success(entity))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
