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
        case ConnectionStateAction.start:
            return ConnectionState(isTesting: true)
        case ConnectionStateAction.update:
            return ConnectionState(isTesting: true)
        case ConnectionStateAction.finish:
            return ConnectionState(isTesting: false)
        default:
            return state
        }
    }
}
