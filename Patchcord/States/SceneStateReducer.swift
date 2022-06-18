//
//  SceneStateReducer.swift
//  Patchcord
//
//  Created by Maksym Bilan on 15.06.2022.
//

import Foundation

extension SceneState {

    static let reducer: Reducer<Self> = { state, action in
        var screens = state.screens

        // Update visible screens
        if let action = action as? ScreenStateAction {
            switch action {
                case .show(.connection):
                    screens = [.connection(.notStarted), .history(HistoryState())]
                case .show(.history):
                    screens = [.history(HistoryState()), .connection(.notStarted)]
                case .dismiss(let screen):
                    screens = screens.filter { $0 != screen }
            }
        }

        // Reduce each screen state
        screens = screens.map { ScreenState.reducer($0, action) }

        return SceneState(screens: screens)
    }

    func screenState<State>(for screen: Screen) -> State? {
        return screens
            .compactMap {
                switch ($0, screen) {
                    case (.connection(let state), .connection):
                        return state as? State
                    case (.history(let state), .history):
                        return state as? State
                    default:
                        return nil
                }
            }
            .first
    }

}
