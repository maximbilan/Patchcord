//
//  HistoryState.swift
//  Patchcord
//
//  Created by Maksym Bilan on 15.06.2022.
//

import Foundation

struct HistoryState {
    let isLoading: Bool
    let results: [Test]
}

extension HistoryState {
    init() {
        isLoading = false
        results = []
    }
}
