//
//  RootView.swift
//  Patchcord
//
//  Created by Maksym Bilan on 12.06.2022.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            ConnectionTestView()
                .tabItem {
                    Label("Connection Test", systemImage: "antenna.radiowaves.left.and.right.circle.fill")
                }
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "list.bullet.rectangle.fill")
                }
        }

    }
}

struct ConnectionTestView: View {
    var body: some View {
        Text("Test connection")
    }
}

struct HistoryView: View {
    var body: some View {
        Text("History")
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
