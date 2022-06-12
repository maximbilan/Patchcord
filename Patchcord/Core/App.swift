//
//  PatchcordApp.swift
//  Patchcord
//
//  Created by Maksym Bilan on 11.06.2022.
//

import SwiftUI

let store = Store(initial: SceneState(),
                  reducer: SceneState.reducer,
                  middlewares: [])

@main
struct PatchcordApp: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
