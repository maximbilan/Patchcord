//
//  ConnectionStateReducer.swift
//  Patchcord
//
//  Created by Maksym Bilan on 13.06.2022.
//

import Foundation

extension ConnectionState {

    static let reducer: Reducer<Self> = { state, action in
        switch action {
        case ConnectionStateAction.startTest:
            return ConnectionState(testState: .started)
        case ConnectionStateAction.cancelTest:
            return ConnectionState(testState: .canceled)
        case ConnectionStateAction.refreshScreen(let state):
            return state
        default:
            return state
        }
    }

}
