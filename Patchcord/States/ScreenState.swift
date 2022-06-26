//
//  ScreenState.swift
//  Patchcord
//
//  Created by Maksym Bilan on 15.06.2022.
//

import Foundation

enum ScreenState {
    case connection(ConnectionState)
    case history(HistoryState)
}

extension ScreenState {

    static func == (lhs: ScreenState, rhs: Screen) -> Bool {
        switch (lhs, rhs) {
        case (.connection, .connection):
            return true
        case (.history, .history):
            return true
        default:
            return false
        }
    }

    static func == (lhs: Screen, rhs: ScreenState) -> Bool {
        rhs == lhs
    }

    static func != (lhs: Screen, rhs: ScreenState) -> Bool {
        !(lhs == rhs)
    }

    static func != (lhs: ScreenState, rhs: Screen) -> Bool {
        !(lhs == rhs)
    }

}
