//
//  TestState.swift
//  Patchcord
//
//  Created by Maksym Bilan on 18.06.2022.
//

import Foundation

enum TestState {
    case notStarted
    case started
    case downloading
    case uploading
    case finished
    case canceled
    case interrupted(Error?)
}

extension TestState: Equatable {
    static func == (lhs: TestState, rhs: TestState) -> Bool {
        switch (lhs, rhs) {
        case (.notStarted, .notStarted):
            return true
        case (.started, .started):
            return true
        case (.downloading, .downloading):
            return true
        case (.uploading, .uploading):
            return true
        case (.finished, .finished):
            return true
        case (.canceled, .canceled):
            return true
        case (.interrupted(_), .interrupted(_)):
            return true
        default:
            return false
        }

    }



}
