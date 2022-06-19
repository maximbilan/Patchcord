//
//  ProcessInfo+Extensions.swift
//  Patchcord
//
//  Created by Maksym Bilan on 19.06.2022.
//

import Foundation

extension ProcessInfo {

    static var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    static var isRunningUITests: Bool {
        return ProcessInfo.processInfo.arguments.contains("UITESTS")
    }

}
