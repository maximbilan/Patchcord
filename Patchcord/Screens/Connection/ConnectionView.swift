//
//  ConnectionView.swift
//  Patchcord
//
//  Created by Maksym Bilan on 13.06.2022.
//

import SwiftUI
import SwiftIPConfig

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
        Form {
            Group {
                Section {
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
                }
                if state?.testState != .notStarted {
                    Section("Result") {
                        if let ip = SwiftIPConfig.getIP() {
                            GroupLabelView(left: "IP Address", right: ip)
                        }
                        if let router = SwiftIPConfig.getGatewayIP() {
                            GroupLabelView(left: "Router", right: router)
                        }
                        if let subnetMask = SwiftIPConfig.getNetmask() {
                            GroupLabelView(left: "Subnet Mask", right: subnetMask)
                        }
                        if let ping = state?.ping {
                            GroupLabelView(left: "Ping", right: "\(ping * 1000) ms")
                        }
                        if let jitter = state?.jitter {
                            GroupLabelView(left: "Jitter", right: "\(jitter * 1000) ms")
                        }
                        if let packetLoss = state?.packetLoss {
                            GroupLabelView(left: "Packet Loss", right: "\(packetLoss) %")
                        }
                        if let downloadSpeed = state?.downloadSpeed {
                            GroupLabelView(left: "Downloading speed", right: "\(downloadSpeed) Mbit/s")
                        }
                        if let uploadSpeed = state?.uploadSpeed {
                            GroupLabelView(left: "Uploading speed", right: "\(uploadSpeed) Mbit/s")
                        }
                    }
                }
            }
        }
        .navigationTitle("Patchcord")
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
