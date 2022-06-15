//
//  ScreenStateReducer.swift
//  Patchcord
//
//  Created by Maksym Bilan on 15.06.2022.
//

import Foundation

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
