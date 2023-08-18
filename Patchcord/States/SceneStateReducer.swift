//
//  SceneStateReducer.swift
//  Patchcord
//
//  Created by Maksym Bilan on 15.06.2022.
//

import Foundation

extension SceneState {

    static let reducer: Reducer<Self> = { state, action in
        SceneState(screens: state.screens.map { ScreenState.reducer($0, action) })
    }

}
