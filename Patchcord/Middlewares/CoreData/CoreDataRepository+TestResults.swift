//
//  CoreDataRepository+TestResults.swift
//  Patchcord
//
//  Created by Maksym Bilan on 17.06.2022.
//

import Foundation
import Combine

extension CoreDataRepository {

    func save(_ state: ConnectionState) -> AnyPublisher<Entity, Error> {
        return add { entity in
            guard let test = entity as? TestResult else {
                return
            }
            test.timestamp = Date()
            test.server = state.server
            test.serverLocation = state.serverLocation
            test.ip = state.ip
            test.gateway = state.gateway
            test.netmask = state.netmask
            if let downloadSpeed = state.downloadSpeed {
                test.downloadSpeed = downloadSpeed
            }
            if let uploadSpeed = state.uploadSpeed {
                test.uploadSpeed = uploadSpeed
            }
            if let ping = state.ping {
                test.ping = ping
            }
            if let jitter = state.jitter {
                test.jitter = jitter
            }
            if let packetLoss = state.packetLoss {
                test.packetLoss = packetLoss
            }
        }
    }

}
