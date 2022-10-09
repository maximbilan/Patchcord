//
//  ConnectionStartView.swift
//  Patchcord
//
//  Created by Maksym Bilan on 09.10.2022.
//

import SwiftUI

struct ConnectionStartView: View {
    var action: (() -> Void)? = nil

    @State private var shadowRadius: CGFloat = 0
    @State private var scale: CGSize = CGSize(width: 1.0, height: 1.0)

    var body: some View {
        ZStack {
            Button {
                action?()
            } label: {
                Text(Strings.start.uppercased())
                    .foregroundColor(.white)
                    .bold()
                    .padding(.all, 30)
            }
            .background(Color.accentColor)
            .mask(Circle())
            .scaleEffect(scale)
            .shadow(color: Color.accentColor, radius: shadowRadius)
            .animation(.easeInOut(duration: 1.3).repeatForever(), value: scale)
            .animation(.easeInOut(duration: 1.3).repeatForever(), value: shadowRadius)
        }
        .onAppear {
            shadowRadius = 30
            scale = CGSize(width: 1.2, height: 1.2)
        }
    }
}


struct ConnectionStartView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionStartView()
    }
}
