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
                    ConnectionStartButton {
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
            case .fetchingPublicIP:
                Group {
                    Text("Fetching public IP...")
                    Divider()
                    Button("Cancel") {
                        store.dispatch(ConnectionStateAction.cancelTest)
                    }
                }
            case .pinging:
                Group {
                    Text("Pinging...")
                    Divider()
                    Button("Cancel") {
                        store.dispatch(ConnectionStateAction.cancelTest)
                    }
                }
            case .startedSpeedTest:
                Group {
                    Text("Starting speed test...")
                    if let ping = state?.ping {
                        Text("Ping: \(ping * 1000) ms")
                    }
                    if let jitter = state?.jitter {
                        Text("Jitter: \(jitter * 1000) ms")
                    }
                    if let packetLoss = state?.packetLoss {
                        Text("Packet loss: \(packetLoss) %")
                    }
                    Divider()
                    Button("Cancel") {
                        store.dispatch(ConnectionStateAction.cancelTest)
                    }
                }
            case .downloading:
                Group {
                    if let ping = state?.ping {
                        Text("Ping: \(ping * 1000) ms")
                    }
                    if let jitter = state?.jitter {
                        Text("Jitter: \(jitter * 1000) ms")
                    }
                    if let packetLoss = state?.packetLoss {
                        Text("Packet loss: \(packetLoss) %")
                    }
                    Divider()
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
                    if let ping = state?.ping {
                        Text("Ping: \(ping * 1000) ms")
                    }
                    if let jitter = state?.jitter {
                        Text("Jitter: \(jitter * 1000) ms")
                    }
                    if let packetLoss = state?.packetLoss {
                        Text("Packet loss: \(packetLoss) %")
                    }
                    Divider()
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
            case .finishedSpeedTest:
                Group {
                    Group {
                        if let ping = state?.ping {
                            Text("Ping: \(ping * 1000) ms")
                        }
                        if let jitter = state?.jitter {
                            Text("Jitter: \(jitter * 1000) ms")
                        }
                        if let packetLoss = state?.packetLoss {
                            Text("Packet loss: \(packetLoss) %")
                        }
                    }

                    Divider()

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
                    }

                    Divider()

                    Group {
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
