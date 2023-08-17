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
    let downloadSpeed: Double?
    let uploadSpeed: Double?

    var body: some View {
        Section("Result") {
            if let ip {
                GroupLabelView(left: "IP Address", right: ip)
            }
            if let router {
                GroupLabelView(left: "Router", right: router)
            }
            if let subnetMask {
                GroupLabelView(left: "Subnet Mask", right: subnetMask)
            }
            if let ping {
                GroupLabelView(left: "Ping", right: String(format: "%.0f ms", ping * 1000))
            }
            if let jitter {
                GroupLabelView(left: "Jitter", right: String(format: "%.0f ms", jitter * 1000))
            }
            if let packetLoss {
                GroupLabelView(left: "Packet Loss", right: String(format: "%.1f /%", packetLoss))
            }
            if let downloadSpeed {
                GroupLabelView(left: "Downloading speed", right: String(format: "%.0f Mbit/s", downloadSpeed))
            }
            if let uploadSpeed {
                GroupLabelView(left: "Uploading speed", right: String(format: "%.0f Mbit/s", uploadSpeed))
            }
        }
    }
}
