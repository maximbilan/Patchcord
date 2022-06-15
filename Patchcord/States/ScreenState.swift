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
    //    case about
}

extension ScreenState {

    static func == (lhs: ScreenState, rhs: ScreenState) -> Bool {
        switch (lhs, rhs) {
            case (.connection, .connection):
                return true
            case (.history, .history):
                return true
            default:
                return false
        }
    }

    static func != (lhs: ScreenState, rhs: ScreenState) -> Bool {
        !(lhs == rhs)
    }

}
