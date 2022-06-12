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
        screens = [.root]
    }
}

extension SceneState {

    static let reducer: Reducer<Self> = { state, action in
        var screens = state.screens

        // Update visible screens
        if let action = action as? ScreenStateAction {
            switch action {
                case .show(.root):
                    screens = [.root]
                case .show(.about):
                    screens = [.root, .about]
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
//    case root(ConnectionState, HistoryState)
    case root
    case about
}

extension ScreenState {

    static let reducer: Reducer<Self> = { state, action in
        switch state {
            case .root:
                return .root
            case .about:
                return .about
        }
    }
}

enum ScreenStateAction: Action {
    case show(ScreenState)
    case dismiss(ScreenState)
}

struct ConnectionState {
    let isTesting: Bool
}

extension ConnectionState {
    init() {
        isTesting = false
    }
}

struct HistoryState {
    let isLoading: Bool
}

extension HistoryState {
    init() {
        isLoading = false
    }
}
