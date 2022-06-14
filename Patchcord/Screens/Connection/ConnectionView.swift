//
//  ConnectionView.swift
//  Patchcord
//
//  Created by Maksym Bilan on 13.06.2022.
//

import SwiftUI

struct ConnectionView: View {
    @ObservedObject var connection = ConnectionMiddleware.shared
    @EnvironmentObject var store: Store<SceneState>

    var body: some View {
        VStack {
            switch connection.state {
            case .notStarted, .canceled:
                Group {
                    Text("Test connection")
                    Divider()
                    Button("Start") {
                        store.dispatch(ConnectionStateAction.start)
                    }
                }
            case .started:
                Group {
                    Text("Starting...")
                    Divider()
                    Button("Cancel") {
                        store.dispatch(ConnectionStateAction.cancel)
                    }
                }
            case .downloading:
                Group {
                    Text("Downloading speed")
                    if let downloadSpeed = connection.downloadSpeed {
                        Text("\(downloadSpeed) Mbit/s")
                    } else {
                        Text("... Mbit/s")
                    }
                    Divider()
                    Button("Cancel") {
                        store.dispatch(ConnectionStateAction.cancel)
                    }
                }
            case .uploading:
                Group {
                    Text("Uploading speed")
                    if let uploadSpeed = connection.uploadSpeed {
                        Text("\(uploadSpeed) Mbit/s")
                    } else {
                        Text("... Mbit/s")
                    }
                    Divider()
                    Button("Cancel") {
                        store.dispatch(ConnectionStateAction.cancel)
                    }
                }
            case .finished:
                Group {
                    Text("Downloading speed")
                    if let downloadSpeed = connection.downloadSpeed {
                        Text("\(downloadSpeed) Mbit/s")
                    } else {
                        Text("... Mbit/s")
                    }
                    Divider()
                    Text("Uploading speed")
                    if let uploadSpeed = connection.uploadSpeed {
                        Text("\(uploadSpeed) Mbit/s")
                    } else {
                        Text("... Mbit/s")
                    }
                    Divider()
                    Button("Run again") {
                        store.dispatch(ConnectionStateAction.start)
                    }
                }
            default:
                Group {
                    Text("Something wrong!")
                    Divider()
                    Button("Try again") {
                        store.dispatch(ConnectionStateAction.start)
                    }
                }
            }
        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
    }
}
