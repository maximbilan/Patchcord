//
//  AppState.swift
//  Patchcord
//
//  Created by Maksym Bilan on 12.06.2022.
//

import Foundation

struct SceneState {
    let screens: [ScreenState]
}

extension SceneState {
    init() {
        screens = [.connection(ConnectionState()),
                   .history(HistoryState())]
    }
}

extension SceneState {

    static let reducer: Reducer<Self> = { state, action in
        var screens = state.screens

        // Update visible screens
        if let action = action as? ScreenStateAction {
            switch action {
            case .show(.connection):
                screens = [.connection(ConnectionState()), .history(HistoryState())]
            case .show(.history):
                screens = [.history(HistoryState()), .connection(ConnectionState())]
            case .dismiss(let screen):
                screens = screens.filter { $0 != screen }
            }
        }

        // Reduce each screen state
        screens = screens.map { ScreenState.reducer($0, action) }

        return SceneState(screens: screens)
    }

}

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

extension ScreenState {

    static let reducer: Reducer<Self> = { state, action in
        switch state {
        case .connection(let state):
            return .connection(ConnectionState.reducer(state, action))
        case .history(let state):
            return .history(HistoryState.reducer(state, action))
//        case .about:
//            return .about
        }
    }
}

enum ScreenStateAction: Action {
    case show(ScreenState)
    case dismiss(ScreenState)
}

struct HistoryState {
    let isLoading: Bool
}

extension HistoryState {
    init() {
        isLoading = false
    }
}

extension HistoryState {
    static let reducer: Reducer<Self> = { state, action in
        return state
    }
}
