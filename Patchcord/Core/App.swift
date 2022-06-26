//
//  PatchcordApp.swift
//  Patchcord
//
//  Created by Maksym Bilan on 11.06.2022.
//

import SwiftUI

/// Local storage 💾
let persistence = Persistence()
let coreData = CoreDataMiddleware(context: persistence.container.viewContext)

/// Connection tests 🛰
let connection = ConnectionMiddleware()

/// Logging 🧯
let logger = LoggerMiddleware()

/// Redux store ♻️
let store = Store(initial: SceneState(),
                  reducer: SceneState.reducer,
                  middlewares: [connection.middleware,
                                coreData.middleware,
                                logger.middleware])

@main
struct PatchcordApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}
