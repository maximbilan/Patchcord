//
//  Ping.swift
//  Patchcord
//
//  Created by Maksym Bilan on 26.06.2022.
//

import Foundation
import SwiftyPing

protocol PingDelegate: AnyObject {
    func pingDidRecieve(_ duration: TimeInterval)
    func pingDidFinish(_ result: PingResult?)
    func pingDidFail(_ error: Error)
}

struct PingResult {
    let ping: TimeInterval
    let jitter: TimeInterval
    let packetLoss: Double?
}

final class PingManager {
    private let queue: DispatchQueue
    private let host: String
    private(set) var tester: SwiftyPing?
    weak var delegate: PingDelegate?

    private static let pingInterval: TimeInterval = 1.0
    private static let timeoutInterval: TimeInterval = 5.0
    private static let targetCount: Int = 10

    init(host: String, queue: DispatchQueue = DispatchQueue.global()) {
        self.host = host
        self.queue = queue
    }

    func start() {
        tester = try? SwiftyPing(host: host,
                                 configuration: PingConfiguration(interval: PingManager.pingInterval, with: PingManager.timeoutInterval),
                                 queue: queue)
        tester?.observer = { [weak self] response in
            let duration = response.duration
            print(duration)
            self?.delegate?.pingDidRecieve(duration)
        }
        tester?.finished = { [weak self] result in
            guard let ping = result.roundtrip?.average, let jitter = result.roundtrip?.standardDeviation else {
                self?.delegate?.pingDidFinish(nil)
                return
            }
            self?.delegate?.pingDidFinish(PingResult(ping: ping, jitter: jitter, packetLoss: result.packetLoss))
        }
        tester?.targetCount = PingManager.targetCount
        do {
            try tester?.startPinging()
        } catch {
            delegate?.pingDidFail(error)
        }
    }

    func stop() {
        tester?.stopPinging()
    }

}
