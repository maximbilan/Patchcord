//
//  PatchcordApp.swift
//  Patchcord
//
//  Created by Maksym Bilan on 11.06.2022.
//

import SwiftUI

let persistance = Persistence()
let connection = ConnectionMiddleware()
let coreData = CoreDataMiddleware(context: persistance.container.viewContext)
let store = Store(initial: SceneState(),
                  reducer: SceneState.reducer,
                  middlewares: [connection.middleware,
                                coreData.middleware])

@main
struct PatchcordApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}
