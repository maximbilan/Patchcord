//
//  ConnectionService.swift
//  Patchcord
//
//  Created by Maksym Bilan on 14.06.2022.
//

import Combine
import SwiftUI
import NDT7

class ConnectionMiddleware: ObservableObject {
    static let shared = ConnectionMiddleware()

    private let queue: DispatchQueue
    private var ndt7Test: NDT7TestDependency?
    private var state: TestState = .notStarted {
        didSet {
            dispatchData()
        }
    }
    private var connectionState: ConnectionState {
        ConnectionState(testState: state,
                        downloadSpeed: downloadSpeed,
                        uploadSpeed: uploadSpeed,
                        server: server,
                        serverLocation: serverLocation)
    }
    private var downloadSpeed: Double?
    private var uploadSpeed: Double?
    private var server: String?
    private var serverLocation: String?

    init() {
        queue = DispatchQueue.main
    }

    func createTest() -> NDT7TestDependency {
        NDT7TestDependency(delegate: self)
    }

    func middleware(state: SceneState, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case ConnectionStateAction.startTest:
            start()
        case ConnectionStateAction.cancelTest:
            cancel()
        default:
            break
        }
        return Empty().eraseToAnyPublisher()
    }

}

fileprivate extension ConnectionMiddleware {

    func start() {
        reset()

        ndt7Test = createTest()
        ndt7Test?.startTest(download: true, upload: true) { [weak self] error in
            if let error = error {
                self?.state = .interrupted(error)
            } else {
                self?.state = .finished
                self?.saveData()
            }
        }

        state = .started
    }

    func reset() {
        downloadSpeed = nil
        uploadSpeed = nil
        state = .notStarted
    }

    func cancel() {
        ndt7Test?.cancel()
        state = .canceled
    }

}

extension ConnectionMiddleware: NDT7TestInteraction {

    func test(kind: NDT7TestConstants.Kind, running: Bool) {
        switch kind {
        case .download:
            state = .downloading
        case .upload:
            state = .uploading
        }
    }

    func measurement(origin: NDT7TestConstants.Origin, kind: NDT7TestConstants.Kind, measurement: NDT7Measurement) {
        if let currentServer = ndt7Test?.test.settings.currentServer {
            server = currentServer.machine
            if let country = currentServer.location?.country, let city = currentServer.location?.city {
                serverLocation = "\(city), \(country)"
            }
        }

        if origin == .client,
           let elapsedTime = measurement.appInfo?.elapsedTime,
           let numBytes = measurement.appInfo?.numBytes,
           elapsedTime >= 1000000 {
            let seconds = elapsedTime / 1000000
            let mbit = numBytes / 125000
            let rounded = Double(Float64(mbit)/Float64(seconds)).rounded(toPlaces: 1)
            switch kind {
            case .download:
                downloadSpeed = rounded
            case .upload:
                uploadSpeed = rounded
            }
        } else if origin == .server,
                  let elapsedTime = measurement.tcpInfo?.elapsedTime,
                  elapsedTime >= 1000000 {
            let seconds = elapsedTime / 1000000
            switch kind {
            case .download:
                if let numBytes = measurement.tcpInfo?.bytesSent {
                    let mbit = numBytes / 125000
                    let rounded = Double(Float64(mbit)/Float64(seconds)).rounded(toPlaces: 1)
                    downloadSpeed = rounded
                }
            case .upload:
                if let numBytes = measurement.tcpInfo?.bytesReceived {
                    let mbit = numBytes / 125000
                    let rounded = Double(Float64(mbit)/Float64(seconds)).rounded(toPlaces: 1)
                    uploadSpeed = rounded
                }
            }
        }

        dispatchData()
    }

    func error(kind: NDT7TestConstants.Kind, error: NSError) {
        ndt7Test?.cancel()
        state = .interrupted(error)
    }

}

/// Dispatches
fileprivate extension ConnectionMiddleware {

    func dispatchInQueue(_ action: ConnectionStateAction) {
        if ProcessInfo.isRunningTests {
            store.dispatch(action)
        } else {
            queue.async {
                store.dispatch(action)
            }
        }
    }

    func saveData() {
        dispatchInQueue(ConnectionStateAction.saveResults(connectionState))
    }

    func dispatchData() {
        dispatchInQueue(ConnectionStateAction.refreshScreen(connectionState))
    }

}

fileprivate extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
