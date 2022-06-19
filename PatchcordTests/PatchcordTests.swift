//
//  PatchcordTests.swift
//  PatchcordTests
//
//  Created by Maksym Bilan on 11.06.2022.
//

import XCTest
import NDT7
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
        let persistance = Persistence(inMemory: true)
        let connection = ConnectionMock()
        let coreData = CoreDataMiddleware(context: persistance.container.newBackgroundContext())
        let store = Store(initial: SceneState(),
                          reducer: SceneState.reducer,
                          middlewares: [connection.middleware, coreData.middleware],
                          runLoop: RunLoop())
        connection.connectStore(store)

        store.dispatch(ConnectionStateAction.saveResults(ConnectionState(testState: .finished,
                                                                         downloadSpeed: 99,
                                                                         uploadSpeed: 99,
                                                                         server: "Starlink",
                                                                         serverLocation: "San Francisco, US")))
//        store.dispatch(HistoryStateAction.fetchHistory)
        let historyState1: HistoryState! = store.state.screenState(for: .history)
        XCTAssertFalse(historyState1.isLoading)
        XCTAssertFalse(historyState1.results.isEmpty)

//        store.dispatch(ConnectionStateAction.saveResults(ConnectionState(testState: .finished,
//                                                                         downloadSpeed: 33,
//                                                                         uploadSpeed: 33,
//                                                                         server: "Starlink",
//                                                                         serverLocation: "Paris, France")))
//        let historyState2: HistoryState! = store.state.screenState(for: .history)
//        XCTAssertFalse(historyState2.isLoading)
//        XCTAssertFalse(historyState2.results.isEmpty)


    }

}
