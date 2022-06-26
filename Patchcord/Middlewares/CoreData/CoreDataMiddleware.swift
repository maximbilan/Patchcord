//
//  CoreDataMiddleware.swift
//  Patchcord
//
//  Created by Maksym Bilan on 17.06.2022.
//

import CoreData
import Combine

/// Middleware that handles all operations with the local database 💾
final class CoreDataMiddleware {
    let context: NSManagedObjectContext
    let testResultsRepository: CoreDataRepository<TestResult>

    init(context: NSManagedObjectContext) {
        self.context = context
        self.testResultsRepository = CoreDataRepository<TestResult>(context: context)
    }

    func middleware(state: SceneState, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case ConnectionStateAction.saveResults(let result):
            return testResultsRepository
                    .save(result)
                    .map { HistoryStateAction.didReceiveTests(self.testResultsRepository.fetchedItems + [$0]) }
                    .ignoreError()
                    .eraseToAnyPublisher()
        case HistoryStateAction.fetchHistory:
            return testResultsRepository
                    .fetch(sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)])
                    .map { HistoryStateAction.didReceiveTests($0) }
                    .ignoreError()
                    .eraseToAnyPublisher()
        case HistoryStateAction.deleteItems(let offsets):
            return testResultsRepository
                    .delete(offsets)
                    .map { HistoryStateAction.fetchHistory }
                    .ignoreError()
                    .eraseToAnyPublisher()
        default:
            return Empty().eraseToAnyPublisher()
        }
    }
}
