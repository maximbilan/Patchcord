//
//  Store.swift
//  Patchcord
//
//  Created by Maksym Bilan on 12.06.2022.
//

import Combine
import SwiftUI

/// Redux store ♻️
final class Store<State>: ObservableObject {
    var isEnabled = true

    @Published private(set) var state: State
    private var tasks: [UUID: AnyCancellable] = [:]
    private let queue: DispatchQueue
    private let reducer: Reducer<State>
    private let middlewares: [Middleware<State>]
    private let runLoop: RunLoop

    init(initial state: State,
         reducer: @escaping Reducer<State>,
         middlewares: [Middleware<State>],
         runLoop: RunLoop = RunLoop.main) {
        self.state = state
        self.queue = DispatchQueue(label: "Patchcord.mainQueue", qos: .userInitiated)
        self.reducer = reducer
        self.middlewares = middlewares
        self.runLoop = runLoop
    }

    func restoreState(_ state: State) {
        self.state = state
    }

    func dispatch(_ action: Action) {
        guard isEnabled else {
            return
        }

        if ProcessInfo.isRunningTests {
            dispatch(state, action)
        } else {
            queue.sync {
                dispatch(state, action)
            }
        }
    }

    private func dispatch(_ currentState: State, _ action: Action) {
        let newState = reducer(currentState, action)

        middlewares.forEach { middleware in
            let key = UUID()
            middleware(newState, action)
                .receive(on: runLoop)
                .handleEvents(receiveCompletion: { [weak self] _ in
                    self?.tasks.removeValue(forKey: key)
                })
                .sink(receiveValue: dispatch)
                .store(in: &tasks, key: key)
        }

        if action.animated {
            withAnimation {
                state = newState
            }
        } else {
            state = newState
        }
    }
}

fileprivate extension AnyCancellable {

    func store(in dictionary: inout [UUID: AnyCancellable], key: UUID) {
        dictionary[key] = self
    }

}
