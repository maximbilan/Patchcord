//
//  LoggerMiddleware.swift
//  Patchcord
//
//  Created by Maksym Bilan on 19.06.2022.
//

import Combine

/// Middleware that logs all states in the console ✍️
final class LoggerMiddleware {

    func middleware(state: SceneState, action: Action) -> AnyPublisher<Action, Never> {
        let stateDescription = "\(state)".replacingOccurrences(of: "Patchcord.", with: "")
        #if DEBUG
        print("➡️ \(action)\n✅ \(stateDescription)\n")
        #endif
        return Empty().eraseToAnyPublisher()
    }

}
