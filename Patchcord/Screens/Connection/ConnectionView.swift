//
//  ConnectionView.swift
//  Patchcord
//
//  Created by Maksym Bilan on 13.06.2022.
//

import SwiftUI

struct ConnectionView: View {
    @EnvironmentObject var store: Store<SceneState>

    var body: some View {
        VStack {
            Text("Test connection")
            Divider()
            Button("Start") {
                store.dispatch(ConnectionStateAction.start)
            }
        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
    }
}
