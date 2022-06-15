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
        screens = [.connection(ConnectionState.notStarted),
                   .history(HistoryState())]
    }
}
