//
//  ConnectionStateAction.swift
//  Patchcord
//
//  Created by Maksym Bilan on 13.06.2022.
//

import Foundation

enum ConnectionStateAction: Action {
    case startTest
    case cancelTest
    case saveResults(ConnectionTestResult)
}

struct ConnectionTestResult {
    let downloadSpeed: Double
    let uploadSpeed: Double
}
