//
//  ConnectionService.swift
//  Patchcord
//
//  Created by Maksym Bilan on 14.06.2022.
//

import Combine
import SwiftUI
import NDT7

class ConnectionMiddleware {
    private var connectedStore: Store<SceneState>?
    private let queue: DispatchQueue
    private let ipConfig: IPConfig
    private var pingManager: PingManager?
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
                        serverLocation: serverLocation,
                        ping: ping,
                        jitter: jitter,
                        packetLoss: packetLoss)
    }
    private var publicIP: String?
    private var downloadSpeed: Double?
    private var uploadSpeed: Double?
    private var server: String?
    private var serverLocation: String?
    private var ping: TimeInterval?
    private var jitter: TimeInterval?
    private var packetLoss: Double?

    init(ipConfig: IPConfig = IPConfig()) {
        queue = DispatchQueue.main
        self.ipConfig = ipConfig
    }

    func createTest() -> NDT7TestDependency {
        NDT7TestDependency(delegate: self)
    }

    func createPingManager(with host: String) -> PingManager {
        PingManager(host: host)
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

    func connectStore(_ store: Store<SceneState>) {
        self.connectedStore = store
    }

}

fileprivate extension ConnectionMiddleware {

    func start() {
        reset()
        state = .started

        ipConfig.getPublicIP { [weak self] publicIP in
            self?.publicIP = publicIP
            self?.startPinging()
        }

        state = .fetchingPublicIP
    }

    func startPinging() {
        let host = publicIP ?? "8.8.8.8"
        pingManager = createPingManager(with: host)
        pingManager?.delegate = self
        pingManager?.start()

        state = .pinging
    }

    func startSpeedTest() {
        ndt7Test = createTest()
        ndt7Test?.startTest(download: true, upload: true) { [weak self] error in
            if let error = error {
                self?.state = .interrupted(error)
            } else {
                self?.state = .finishedSpeedTest
                self?.saveData(deadline: .now() + 1.0)
            }
        }

        state = .startedSpeedTest
    }

    func reset() {
        pingManager = nil
        downloadSpeed = nil
        uploadSpeed = nil
        ping = nil
        jitter = nil
        packetLoss = nil
        state = .notStarted
    }

    func cancel() {
        ndt7Test?.cancel()
        pingManager?.stop()
        state = .canceled
    }

}

extension ConnectionMiddleware: NDT7TestInteraction {

    func test(kind: NDT7TestConstants.Kind, running: Bool) {
        guard state != .canceled || state != .finishedSpeedTest else {
            return
        }

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

    func dispatchInQueue(_ action: ConnectionStateAction, deadline: DispatchTime) {
        if ProcessInfo.isRunningTests {
            connectedStore?.dispatch(action)
        } else {
            queue.asyncAfter(deadline: deadline) { [weak self] in
                self?.connectedStore?.dispatch(action)
            }
        }
    }

    func saveData(deadline: DispatchTime = .now()) {
        dispatchInQueue(ConnectionStateAction.saveResults(connectionState), deadline: deadline)
    }

    func dispatchData(deadline: DispatchTime = .now()) {
        dispatchInQueue(ConnectionStateAction.refreshScreen(connectionState), deadline: deadline)
    }

}

extension ConnectionMiddleware: PingDelegate {

    func pingDidRecieve(_ duration: TimeInterval) {
    }

    func pingDidFinish(_ result: PingResult?) {
        ping = result?.ping
        jitter = result?.jitter
        packetLoss = result?.packetLoss

        startSpeedTest()
    }

    func pingDidFail(_ error: Error) {
        startSpeedTest()
    }

}

fileprivate extension Double {

    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

}
