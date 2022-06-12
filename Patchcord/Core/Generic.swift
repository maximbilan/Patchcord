//
//  Generic.swift
//  Patchcord
//
//  Created by Maksym Bilan on 12.06.2022.
//

import Combine

enum Middlewares {}

protocol Action {}

typealias Reducer<State> = (State, Action) -> State
typealias Middleware<State> = (State, Action) -> AnyPublisher<Action, Never>
