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
        let coreData = CoreDataMiddleware(context: persistance.container.viewContext)
        let store = Store(initial: SceneState(),
                          reducer: SceneState.reducer,
                          middlewares: [connection.middleware, coreData.middleware])

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

        connection.test(kind: .download, running: true)

//        let measurement1 = NDT7Measurement.measurement(from: NDT7Measurement.downloadMeasurementJSON)
//        connection.measurement(origin: .server, kind: .download, measurement: measurement1)

        let connectionDownloading: ConnectionState! = store.state.screenState(for: .connection)
        XCTAssertEqual(connectionDownloading.testState, TestState.downloading)
//        XCTAssertEqual(connectionDownloading.downloadSpeed, 0)

//        connection.test(kind: .upload, running: true)

//        let measurement2 = NDT7Measurement.measurement(from: NDT7Measurement.uploadMeasurementJSON)
//        connection.measurement(origin: .server, kind: .upload, measurement: measurement2)

//        XCTAssertEqual(connectionDownloading.testState, TestState.uploading)
//        XCTAssertEqual(connectionDownloading.uploadSpeed, 0)

    }

}
