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
                            NavigationLink {
                                List {
                                    ResultView(testResult: result)
                                }
                                .navigationTitle("Result")
                            } label: {
                                HStack {
                                    if let timestamp = result.timestamp {
                                        Text(timestamp.formatted(.dateTime))
                                    }
                                    Spacer()
                                    Text(String(format: "%.0f/%.0f Mbit/s", result.downloadSpeed, result.uploadSpeed))
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
