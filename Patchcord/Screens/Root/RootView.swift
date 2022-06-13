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
            ConnectionView()
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

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
