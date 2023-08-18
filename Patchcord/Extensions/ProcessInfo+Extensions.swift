//
//  ProcessInfo+Extensions.swift
//  Patchcord
//
//  Created by Maksym Bilan on 19.06.2022.
//

import Foundation

extension ProcessInfo {

    static var isRunningTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

}
