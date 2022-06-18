//
//  HistoryView.swift
//  Patchcord
//
//  Created by Maksym Bilan on 13.06.2022.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: Store<SceneState>
    private var state: HistoryState? { store.state.screenState(for: .history) }

    var body: some View {
        ZStack {
            if let state = state {
                if !state.isLoading {
                    List {
                        ForEach(state.results) { result in
                            VStack(alignment: .leading) {
                                if let timestamp = result.timestamp {
                                    Text(timestamp, formatter: itemFormatter)
                                    Text("\(result.downloadResult)")
                                    Text("\(result.downloadResult)")
                                }
                            }
                        }
                        .onDelete(perform: deleteItems(offsets:))
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

    private func deleteItems(offsets: IndexSet) {
        store.dispatch(HistoryStateAction.deleteItems(offsets))
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
