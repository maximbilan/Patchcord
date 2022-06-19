//
//  LoggerMiddleware.swift
//  Patchcord
//
//  Created by Maksym Bilan on 19.06.2022.
//

import Combine

final class Logger {

    func middleware(state: SceneState, action: Action) -> AnyPublisher<Action, Never> {
        let stateDescription = "\(state)".replacingOccurrences(of: "Patchcord.", with: "")
        print("➡️ \(action)\n✅ \(stateDescription)\n")
        return Empty().eraseToAnyPublisher()
    }

}
