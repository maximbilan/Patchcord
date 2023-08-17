//
//  ConnectionView.swift
//  Patchcord
//
//  Created by Maksym Bilan on 13.06.2022.
//

import SwiftUI

struct ConnectionView: View {
    @EnvironmentObject var store: Store<SceneState>
    private var state: ConnectionState? { store.state.screenState(for: .connection) }

    private var startButtonText: String {
        switch state?.testState {
        case .notStarted, .canceled, .finishedSpeedTest:
            return "Start"
        default:
            return "Cancel"
        }
    }

    private var startButtonAction: ConnectionStateAction {
        switch state?.testState {
        case .notStarted, .canceled, .finishedSpeedTest:
            return .startTest
        default:
            return .cancelTest
        }
    }

    private var statusText: String? {
        switch state?.testState {
        case .notStarted, .canceled, .finishedSpeedTest:
            return nil
        case .started:
            return "Starting"
        case .fetchingPublicIP:
            return "Fetching public IP..."
        case .pinging:
            return "Pinging..."
        case .startedSpeedTest:
            return "Speed measuring..."
        case .downloading:
            return "Downloading..."
        case .uploading:
            return "Uploading..."
        case .interrupted(let error):
            return error?.localizedDescription
        default:
            return nil
        }
    }

    var body: some View {
        List {
            Section("Make a test") {
                HStack {
                    Text("Speedtest")
                    Spacer()
                    Button(startButtonText) {
                        store.dispatch(startButtonAction)
                    }
                }
                if let statusText {
                    GroupLabelView(left: "Status", right: statusText)
                }
                NavigationLink("Results") {
                    HistoryView()
                        .navigationTitle("Results")
                }
            }
            if let state, state.testState != .notStarted {
                ResultView(state: state)
            }
        }
        .navigationTitle("")
        .onAppear {
            connection.connectStore(store)
        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
    }
}
