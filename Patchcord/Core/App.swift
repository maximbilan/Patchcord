//
//  PatchcordApp.swift
//  Patchcord
//
//  Created by Maksym Bilan on 11.06.2022.
//

import SwiftUI
import Combine

enum Middlewares {}

protocol Action {}

typealias Reducer<State> = (State, Action) -> State
typealias Middleware<State> = (State, Action) -> AnyPublisher<Action, Never>

@main
struct PatchcordApp: App {
    let persistenceController = PersistenceController.shared

    

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
