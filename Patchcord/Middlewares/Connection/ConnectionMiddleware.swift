//
//  ConnectionService.swift
//  Patchcord
//
//  Created by Maksym Bilan on 14.06.2022.
//

import Combine
import SwiftUI
import NDT7

final class ConnectionMiddleware: ObservableObject {
    static let shared = ConnectionMiddleware()

    private let queue: DispatchQueue
    private var ndt7Test: NDT7Test?

    @Published var state: ConnectionState = .notStarted
    @Published var downloadSpeed: Double?
    @Published var uploadSpeed: Double?
    @Published var server: String?
    @Published var serverLocation: String?

    init() {
        queue = DispatchQueue.main
    }

    func middleware(state: SceneState, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
        case ConnectionStateAction.start:
            start()
        case ConnectionStateAction.cancel:
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

        let settings = NDT7Settings()
        ndt7Test = NDT7Test(settings: settings)
        ndt7Test?.delegate = self
        ndt7Test?.startTest(download: true, upload: true) { [weak self] error in
            self?.updateState(error != nil ? .interrupted(error) : .finished)
        }

        updateState(.started)
    }

    func reset() {
        state = .notStarted
        downloadSpeed = nil
        uploadSpeed = nil
    }

    func cancel() {
        ndt7Test?.cancel()
        updateState(.canceled)
    }

    func updateState(_ state: ConnectionState) {
        queue.async { [weak self] in
            self?.state = state
        }
    }

}

extension ConnectionMiddleware: NDT7TestInteraction {

    func test(kind: NDT7TestConstants.Kind, running: Bool) {
        switch kind {
        case .download:
            updateState(.downloading)
        case .upload:
            updateState(.uploading)
        }
    }

    func measurement(origin: NDT7TestConstants.Origin, kind: NDT7TestConstants.Kind, measurement: NDT7Measurement) {
        if let currentServer = ndt7Test?.settings.currentServer {
            queue.async { [weak self] in
                self?.server = currentServer.machine
            }
            if let country = currentServer.location?.country, let city = currentServer.location?.city {
                queue.async { [weak self] in
                    self?.serverLocation = "\(city), \(country)"
                }
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
                queue.async { [weak self] in
                    self?.downloadSpeed = rounded
                }
            case .upload:
                queue.async { [weak self] in
                    self?.uploadSpeed = rounded
                }
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
                    queue.async { [weak self] in
                        self?.downloadSpeed = rounded
                    }
                }
            case .upload:
                if let numBytes = measurement.tcpInfo?.bytesReceived {
                    let mbit = numBytes / 125000
                    let rounded = Double(Float64(mbit)/Float64(seconds)).rounded(toPlaces: 1)
                    uploadSpeed = rounded
                    queue.async { [weak self] in
                        self?.uploadSpeed = rounded
                    }
                }
            }
        }
    }

    func error(kind: NDT7TestConstants.Kind, error: NSError) {
        ndt7Test?.cancel()
        updateState(.interrupted(error))
    }

}

fileprivate extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
