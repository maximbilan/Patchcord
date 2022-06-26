//
//  Publisher+Extensions.swift
//  Patchcord
//
//  Created by Maksym Bilan on 26.06.2022.
//

import Combine

extension Publisher {

    func ignoreError() -> AnyPublisher<Output, Never> {
        self
            .catch { _ in Empty() }
            .eraseToAnyPublisher()
    }

}
