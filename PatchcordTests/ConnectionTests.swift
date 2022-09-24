//
//  ConnectionTests.swift
//  PatchcordTests
//
//  Created by Maksym Bilan on 19.06.2022.
//

import XCTest
import NDT7
@testable import Patchcord

final class ConnectionTests: XCTestCase {

    func testStates() {
        // Initializes the app components
        let persistance = Persistence(inMemory: true)
        let connection = ConnectionMock(ipConfig: IPConfigMock())
        let coreData = CoreDataMiddleware(context: persistance.container.newBackgroundContext())
        let logger = LoggerMiddleware()
        let store = Store(initial: SceneState(),
                          reducer: SceneState.reducer,
                          middlewares: [connection.middleware,
                                        coreData.middleware,
                                        logger.middleware],
                          runLoop: RunLoop())
        connection.connectStore(store)

        // Tests initial states
        let connectionNotStarted: ConnectionState! = store.state.screenState(for: .connection)
        let historyInitialState: HistoryState! = store.state.screenState(for: .history)
        XCTAssertEqual(connectionNotStarted.testState, TestState.notStarted)
        XCTAssertFalse(historyInitialState.isLoading)
        XCTAssertTrue(historyInitialState.results.isEmpty)

        // Starts a test
        store.dispatch(ConnectionStateAction.startTest)

        // Tests that the test has been started
        let connectionStarted: ConnectionState! = store.state.screenState(for: .connection)
        XCTAssertEqual(connectionStarted.testState, TestState.started)

        store.dispatch(ConnectionStateAction.cancelTest)

        // Tests that the test has been canceled
        let connectionCanceled: ConnectionState! = store.state.screenState(for: .connection)
        XCTAssertEqual(connectionCanceled.testState, TestState.canceled)

        // Starts testing again
        store.dispatch(ConnectionStateAction.startTest)

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
        XCTAssertEqual(connectionFinished.testState, TestState.finishedSpeedTest)
    }

}
