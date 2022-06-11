//
//  PatchcordApp.swift
//  Patchcord
//
//  Created by Maksym Bilan on 11.06.2022.
//

import SwiftUI

@main
struct PatchcordApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
