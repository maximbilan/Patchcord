//
//  ResultView.swift
//  Patchcord
//
//  Created by Maksym Bilan on 17.08.2023.
//

import SwiftUI

struct ResultView: View {
    let ip: String?
    let router: String?
    let subnetMask: String?
    let ping: Double?
    let jitter: Double?
    let packetLoss: Double?
    let server: String?
    let serverLocation: String?
    let downloadSpeed: Double?
    let uploadSpeed: Double?

    init(testResult: TestResult) {
        ip = testResult.ip
        router = testResult.gateway
        subnetMask = testResult.netmask
        ping = testResult.ping
        jitter = testResult.jitter
        packetLoss = testResult.packetLoss
        server = testResult.server
        serverLocation = testResult.serverLocation
        downloadSpeed = testResult.downloadSpeed
        uploadSpeed = testResult.uploadSpeed
    }

    init(state: ConnectionState) {
        ip = state.ip
        router = state.gateway
        subnetMask = state.netmask
        ping = state.ping
        jitter = state.jitter
        packetLoss = state.packetLoss
        server = state.server
        serverLocation = state.serverLocation
        downloadSpeed = state.downloadSpeed
        uploadSpeed = state.uploadSpeed
    }

    var body: some View {
        Section("Result") {
            if let ip {
                DetailedTextView(left: "IP Address", right: ip)
            }
            if let router {
                DetailedTextView(left: "Router", right: router)
            }
            if let subnetMask {
                DetailedTextView(left: "Subnet Mask", right: subnetMask)
            }
            if let ping {
                DetailedTextView(left: "Ping", right: String(format: "%.0f ms", ping * 1000))
            }
            if let jitter {
                DetailedTextView(left: "Jitter", right: String(format: "%.0f ms", jitter * 1000))
            }
            if let packetLoss {
                DetailedTextView(left: "Packet Loss", right: packetLoss.formatted(.percent))
            }
            if let server {
                DetailedTextView(left: "Server", right: server)
            }
            if let serverLocation {
                DetailedTextView(left: "Server Location", right: serverLocation)
            }
            if let downloadSpeed {
                DetailedTextView(left: "Downloading speed", right: String(format: "%.0f Mbit/s", downloadSpeed))
            }
            if let uploadSpeed {
                DetailedTextView(left: "Uploading speed", right: String(format: "%.0f Mbit/s", uploadSpeed))
            }
        }
    }
}
