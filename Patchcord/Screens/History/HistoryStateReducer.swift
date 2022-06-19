//
//  HistoryStateReducer.swift
//  Patchcord
//
//  Created by Maksym Bilan on 15.06.2022.
//

import Foundation

extension HistoryState {

    static let reducer: Reducer<Self> = { state, action in
        switch action {
        case HistoryStateAction.fetchHistory:
            return HistoryState(isLoading: true, results: [])
        case HistoryStateAction.didReceiveTests(let tests):
            return HistoryState(isLoading: false, results: tests)
        default:
            return state
        }
    }

}
