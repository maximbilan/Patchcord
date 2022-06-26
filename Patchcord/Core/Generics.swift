//
//  Generics.swift
//  Patchcord
//
//  Created by Maksym Bilan on 12.06.2022.
//

import Foundation
import Combine

protocol Action {
    var animated: Bool { get }
}

extension Action {
    var animated: Bool {
        !ProcessInfo.isRunningTests
    }
}

typealias Reducer<State> = (State, Action) -> State
typealias Middleware<State> = (State, Action) -> AnyPublisher<Action, Never>
