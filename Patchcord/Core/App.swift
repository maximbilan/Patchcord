//
//  PatchcordApp.swift
//  Patchcord
//
//  Created by Maksym Bilan on 11.06.2022.
//

import SwiftUI

let store = Store(initial: SceneState(),
                  reducer: SceneState.reducer,
                  middlewares: [ConnectionMiddleware.shared.middleware,
                                PersistenceMiddleware.shared.middleware])

@main
struct PatchcordApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}
