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
            return ConnectionState(testState: .started, downloadSpeed: nil, uploadSpeed: nil, server: nil, serverLocation: nil)
        case ConnectionStateAction.cancelTest:
            return ConnectionState(testState: .canceled, downloadSpeed: nil, uploadSpeed: nil, server: nil, serverLocation: nil)
        default:
            return state
        }
    }
}
