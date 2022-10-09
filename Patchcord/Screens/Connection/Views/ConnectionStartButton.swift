//
//  ConnectionStartView.swift
//  Patchcord
//
//  Created by Maksym Bilan on 09.10.2022.
//

import SwiftUI

struct ConnectionStartButton: View {
    let text: String = Strings.start.uppercased()
    var action: (() -> Void)? = nil

    private let primaryColor: Color = .accentColor
    private let secondaryColor: Color = .white
    private let padding: CGFloat = 32
    private let animationDuration: CGFloat = 1.25
    private let maxShadowRadius: CGFloat = 32
    private let maxScaleFactor: CGFloat = 1.25
    @State private var shadowRadius: CGFloat = 0
    @State private var scale: CGSize = CGSize(width: 1.0, height: 1.0)

    var body: some View {
        ZStack {
            Button {
                action?()
            } label: {
                Text(text)
                    .foregroundColor(secondaryColor)
                    .bold()
                    .padding(.all, padding)
            }
            .background(primaryColor)
            .mask(Circle())
            .scaleEffect(scale)
            .shadow(color: primaryColor, radius: shadowRadius)
            .animation(.easeInOut(duration: animationDuration).repeatForever(), value: scale)
            .animation(.easeInOut(duration: animationDuration).repeatForever(), value: shadowRadius)
        }
        .onAppear {
            shadowRadius = maxShadowRadius
            scale = CGSize(width: maxScaleFactor, height: maxScaleFactor)
        }
    }
}

