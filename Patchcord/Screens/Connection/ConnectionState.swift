//
//  ConnectionState.swift
//  Patchcord
//
//  Created by Maksym Bilan on 13.06.2022.
//

import Foundation

struct ConnectionState {
    let testState: TestState
    var downloadSpeed: Double?
    var uploadSpeed: Double?
    var server: String?
    var serverLocation: String?
    var ping: TimeInterval?
    var jitter: TimeInterval?
    var packetLoss: Double?
    var ip: String?
    var gateway: String?
    var netmask: String?
}

extension ConnectionState {

    init() {
        testState = .notStarted
    }

}
