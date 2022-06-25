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

    var body: some View {
        VStack {
            switch state?.testState {
            case .notStarted, .canceled:
                Group {
                    Text("Test connection")
                    Divider()
                    Button("Start") {
                        store.dispatch(ConnectionStateAction.startTest)
                    }
                }
            case .started:
                Group {
                    Text("Starting...")
                    Divider()
                    Button("Cancel") {
                        store.dispatch(ConnectionStateAction.cancelTest)
                    }
                }
            case .downloading:
                Group {
                    Text("Downloading speed")
                    if let downloadSpeed = state?.downloadSpeed {
                        Text("\(downloadSpeed) Mbit/s")
                    } else {
                        Text("... Mbit/s")
                    }
                    Divider()
                    Button("Cancel") {
                        store.dispatch(ConnectionStateAction.cancelTest)
                    }
                }
            case .uploading:
                Group {
                    Text("Uploading speed")
                    if let uploadSpeed = state?.uploadSpeed {
                        Text("\(uploadSpeed) Mbit/s")
                    } else {
                        Text("... Mbit/s")
                    }
                    Divider()
                    Button("Cancel") {
                        store.dispatch(ConnectionStateAction.cancelTest)
                    }
                }
            case .finished:
                Group {
                    if let ip = SwiftIPConfig.getIP() {
                        Text("IP Address: \(ip)")
                    }
                    if let router = SwiftIPConfig.getGatewayIP() {
                        Text("Router: \(router)")
                    }
                    if let subnetMask = SwiftIPConfig.getNetmask() {
                        Text("Subnet Mask: \(subnetMask)")
                    }
                    Text("Downloading speed")
                    if let downloadSpeed = state?.downloadSpeed {
                        Text("\(downloadSpeed) Mbit/s")
                    } else {
                        Text("... Mbit/s")
                    }
                    Divider()
                    Text("Uploading speed")
                    if let uploadSpeed = state?.uploadSpeed {
                        Text("\(uploadSpeed) Mbit/s")
                    } else {
                        Text("... Mbit/s")
                    }
                    Divider()
                    Button("Run again") {
                        store.dispatch(ConnectionStateAction.startTest)
                    }
                }
            default:
                Group {
                    Text("Something wrong!")
                    Divider()
                    Button("Try again") {
                        store.dispatch(ConnectionStateAction.startTest)
                    }
                }
            }
        }
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
