//
//  PatchcordTests.swift
//  PatchcordTests
//
//  Created by Maksym Bilan on 11.06.2022.
//

import XCTest
import NDT7
import Combine
@testable import Patchcord

final class PatchcordTests: XCTestCase {

    func testConnection() {
        let persistance = Persistence(inMemory: true)
        let connection = ConnectionMock()
        let coreData = CoreDataMiddleware(context: persistance.container.newBackgroundContext())
        let store = Store(initial: SceneState(),
                          reducer: SceneState.reducer,
                          middlewares: [connection.middleware, coreData.middleware],
                          runLoop: RunLoop())
        connection.connectStore(store)

        let connectionNotStarted: ConnectionState! = store.state.screenState(for: .connection)
        let historyInitialState: HistoryState! = store.state.screenState(for: .history)

        // Tests initial states
        XCTAssertEqual(connectionNotStarted.testState, TestState.notStarted)
        XCTAssertFalse(historyInitialState.isLoading)
        XCTAssertTrue(historyInitialState.results.isEmpty)

        // Starts a test
        store.dispatch(ConnectionStateAction.startTest)

        // Tests that the test has been started
        let connectionStarted: ConnectionState! = store.state.screenState(for: .connection)
        XCTAssertEqual(connectionStarted.testState, TestState.started)

        store.dispatch(ConnectionStateAction.cancelTest)

        // Tests that the test has been started
        let connectionCanceled: ConnectionState! = store.state.screenState(for: .connection)
        XCTAssertEqual(connectionCanceled.testState, TestState.canceled)

        // Tests downloading speed
        connection.test(kind: .download, running: true)
        let measurement1 = NDT7Measurement.measurement(from: NDT7Measurement.downloadMeasurementJSON)
        connection.measurement(origin: .server, kind: .download, measurement: measurement1)
        let connectionDownloading: ConnectionState! = store.state.screenState(for: .connection)
        XCTAssertEqual(connectionDownloading.testState, TestState.downloading)
        XCTAssertEqual(connectionDownloading.downloadSpeed, 8)

        // Tests uploading speed
        connection.test(kind: .upload, running: true)
        let measurement2 = NDT7Measurement.measurement(from: NDT7Measurement.uploadMeasurementJSON)
        connection.measurement(origin: .server, kind: .upload, measurement: measurement2)
        let connectionUploading: ConnectionState! = store.state.screenState(for: .connection)
        XCTAssertEqual(connectionUploading.testState, TestState.uploading)
        XCTAssertEqual(connectionUploading.uploadSpeed, 64)

        // Tests finishing up
        connection.finish()
        let connectionFinished: ConnectionState! = store.state.screenState(for: .connection)
        XCTAssertEqual(connectionFinished.testState, TestState.finished)
    }

    func testCoreData() {
        var bag = Set<AnyCancellable>()
        let persistance = Persistence(inMemory: true)
        let coreData = CoreDataMiddleware(context: persistance.container.newBackgroundContext())

        let exp1 = expectation(description: "Adds the first test state")
        let exp2 = expectation(description: "Adds the second test state")

        coreData.testResultsRepository.save(ConnectionState(testState: .finished,
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

        coreData.testResultsRepository.save(ConnectionState(testState: .finished,
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
