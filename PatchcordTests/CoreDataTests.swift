//
//  CoreDataTests.swift
//  PatchcordTests
//
//  Created by Maksym Bilan on 19.06.2022.
//

import XCTest
import Combine
@testable import Patchcord

final class CoreDataTests: XCTestCase {

    func testOperations() {
        // Initializes Core Data middleware
        let persistance = Persistence(inMemory: true)
        let coreData = CoreDataMiddleware(context: persistance.container.newBackgroundContext())
        var bag = Set<AnyCancellable>()

        // Tests saving of the connection result to Core Data storage
        let exp1 = expectation(description: "Adds the first test state")
        coreData.testResultsRepository.save(ConnectionState(testState: .finishedSpeedTest,
                                                            downloadSpeed: 99,
                                                            uploadSpeed: 99,
                                                            server: "Starlink",
                                                            serverLocation: "San Francisco, US"))
        .sink { completion in
            switch completion {
                case .finished:
                    exp1.fulfill()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        } receiveValue: { result in
            XCTAssertEqual(result.downloadSpeed, 99)
            XCTAssertEqual(result.uploadSpeed, 99)
        }
        .store(in: &bag)

        // Tests saving of the connection result to Core Data storage
        let exp2 = expectation(description: "Adds the second test state")
        coreData.testResultsRepository.save(ConnectionState(testState: .finishedSpeedTest,
                                                            downloadSpeed: 33,
                                                            uploadSpeed: 33,
                                                            server: "Space X",
                                                            serverLocation: "Paris, France"))
        .sink { completion in
            switch completion {
                case .finished:
                    exp2.fulfill()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        } receiveValue: { result in
            XCTAssertEqual(result.downloadSpeed, 33)
            XCTAssertEqual(result.uploadSpeed, 33)
        }
        .store(in: &bag)

        wait(for: [exp1, exp2], timeout: 1)

        // Tests fetching saved connection results from Core Data storage
        let exp3 = expectation(description: "Fetches stored entities")
        coreData.testResultsRepository.fetch().sink { completion in
            switch completion {
                case .finished:
                    exp3.fulfill()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        } receiveValue: { results in
            XCTAssertEqual(results.count, 2)
        }
        .store(in: &bag)

        wait(for: [exp3], timeout: 1)

        // Tests removing connection results from Core Data storage
        let exp4 = expectation(description: "Removes one of the entities")
        let indexSet: IndexSet = [1]
        coreData.testResultsRepository.delete(indexSet).sink { completion in
            switch completion {
                case .finished:
                    XCTAssertEqual(coreData.testResultsRepository.fetchedItems.count, 1)
                    exp4.fulfill()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        } receiveValue: { _ in
        }
        .store(in: &bag)

        wait(for: [exp4], timeout: 1)
    }

}
