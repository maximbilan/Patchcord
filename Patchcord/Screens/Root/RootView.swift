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
                    Label(Strings.speed, systemImage: "antenna.radiowaves.left.and.right.circle.fill")
                }
            HistoryView()
                .tabItem {
                    Label(Strings.results, systemImage: "list.bullet.rectangle.fill")
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
