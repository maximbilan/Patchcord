//
//  ConnectionState.swift
//  Patchcord
//
//  Created by Maksym Bilan on 13.06.2022.
//

import Foundation

struct ConnectionState {
    let testState: TestState
    let downloadSpeed: Double?
    let uploadSpeed: Double?
    let server: String?
    let serverLocation: String?
}

extension ConnectionState {

    init() {
        testState = .notStarted
        downloadSpeed = nil
        uploadSpeed = nil
        server = nil
        serverLocation = nil
    }

}
