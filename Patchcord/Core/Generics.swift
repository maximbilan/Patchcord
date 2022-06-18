//
//  Generics.swift
//  Patchcord
//
//  Created by Maksym Bilan on 12.06.2022.
//

import Combine

protocol Action {}
enum Middlewares {}

typealias Reducer<State> = (State, Action) -> State
typealias Middleware<State> = (State, Action) -> AnyPublisher<Action, Never>

extension Publisher {
    func ignoreError() -> AnyPublisher<Output, Never> {
        self
            .catch { _ in Empty() }
            .eraseToAnyPublisher()
    }
}
