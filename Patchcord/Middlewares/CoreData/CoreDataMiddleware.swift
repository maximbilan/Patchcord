//
//  CoreDataMiddleware.swift
//  Patchcord
//
//  Created by Maksym Bilan on 17.06.2022.
//

import CoreData
import Combine

extension Middlewares {
    private static let testResultsRepository = CoreDataRepository<Test>(context: persistance.container.viewContext)

    static let testResults: Middleware<SceneState> = { state, action in
        switch action {
        case ConnectionStateAction.saveResults(let result):
            return testResultsRepository
                    .save(result)
                    .map { HistoryStateAction.didReceiveTests(testResultsRepository.fetchedItems + [$0]) }
                    .ignoreError()
                    .eraseToAnyPublisher()
        case HistoryStateAction.fetchHistory:
            return testResultsRepository
                    .fetch()
                    .map { HistoryStateAction.didReceiveTests($0) }
                    .ignoreError()
                    .eraseToAnyPublisher()
        default:
            return Empty().eraseToAnyPublisher()
        }
    }

}

extension Publisher {
    func ignoreError() -> AnyPublisher<Output, Never> {
        self
            .catch { _ in Empty() }
            .eraseToAnyPublisher()
    }
}
