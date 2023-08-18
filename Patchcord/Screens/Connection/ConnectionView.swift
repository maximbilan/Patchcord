//
//  ConnectionView.swift
//  Patchcord
//
//  Created by Maksym Bilan on 13.06.2022.
//

import SwiftUI

struct ConnectionView: View {
    @EnvironmentObject var store: Store<SceneState>
    fileprivate var state: ConnectionState? { store.state.screenState(for: .connection) }
    @State fileprivate var isPermittedToStart: Bool = false

    var body: some View {
        List {
            Section("Make a test") {
                HStack {
                    Text("Speedtest")
                    Spacer()
                    Text(startButtonText)
                        .foregroundColor(startButtonColor)
                        .onTapGesture {
                            store.dispatch(startButtonAction)
                        }
                        .allowsHitTesting(isPermittedToStart)
                }
                Toggle("I agree to the data policy, which includes retention and publication of IP addresses.",
                       isOn: $isPermittedToStart)
                    .foregroundColor(.secondary)
                    .allowsHitTesting(isPermissionChangingActive)
                if let statusText {
                    DetailedTextView(left: "Status", right: statusText)
                }

            }
            if let state, state.testState != .notStarted {
                ResultView(state: state)
            }
            Section("Other") {
                NavigationLink("Results") {
                    HistoryView()
                        .navigationTitle("Results")
                }
                Link("Data Policy", destination: URL(string: "https://www.measurementlab.net/privacy/")!)
            }
        }
        .navigationTitle("")
        .onAppear {
            connection.connectStore(store)
        }
    }
}

fileprivate extension ConnectionView {

    var startButtonText: String {
        switch state?.testState {
        case .notStarted, .canceled, .finishedSpeedTest:
            return "Start"
        default:
            return "Cancel"
        }
    }

    var startButtonAction: ConnectionStateAction {
        switch state?.testState {
        case .notStarted, .canceled, .finishedSpeedTest:
            return .startTest
        default:
            return .cancelTest
        }
    }

    var startButtonColor: Color {
        isPermittedToStart ? .accentColor : .secondary
    }

    var statusText: String? {
        switch state?.testState {
        case .notStarted, .canceled, .finishedSpeedTest:
            return nil
        case .started:
            return "Starting..."
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

    var isPermissionChangingActive: Bool {
        switch state?.testState {
        case .notStarted, .canceled, .finishedSpeedTest:
            return true
        default:
            return false
        }
    }

}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
    }
}
