//
//  HistoryView.swift
//  Patchcord
//
//  Created by Maksym Bilan on 13.06.2022.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: Store<SceneState>

    private var state: HistoryState? {
        store.state.screenState(for: .history(HistoryState()))
    }

    var body: some View {
        ZStack {
            if let state = state {
                if state.isLoading {
                    List {
                        ForEach(state.results) { result in
                            Text(result.timestamp!, formatter: itemFormatter)
//                            Text(result.downloadSpeed)
//                            Text(result.uploadSpeed)
                        }
                    }
                } else {
                    Text("Loading...")
                }
            }
        }
        .onAppear {
            store.dispatch(HistoryStateAction.fetchHistory)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
