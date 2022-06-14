//
//  PatchcordApp.swift
//  Patchcord
//
//  Created by Maksym Bilan on 11.06.2022.
//

import SwiftUI

// For history
// let persistenceController = PersistenceController.shared

let store = Store(initial: SceneState(),
                  reducer: SceneState.reducer,
                  middlewares: [ConnectionMiddleware.shared.middleware])

@main
struct PatchcordApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}
