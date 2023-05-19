//
//  BackgroundView.swift
//  Patchcord
//
//  Created by Maksym Bilan on 19.05.2023.
//

import SwiftUI

struct BackgroundView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.topBackground, Color.bottomBackground],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
            content
        }
    }
}
