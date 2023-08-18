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

    func screenState<State>(for screen: Screen) -> State? {
        screens.compactMap {
            switch ($0, screen) {
            case (.connection(let state), .connection):
                return state as? State
            case (.history(let state), .history):
                return state as? State
            default:
                return nil
            }
        }.first
    }

}
