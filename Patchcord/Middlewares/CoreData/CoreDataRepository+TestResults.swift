//
//  CoreDataRepository+TestResults.swift
//  Patchcord
//
//  Created by Maksym Bilan on 17.06.2022.
//

import Foundation
import Combine

extension CoreDataRepository {

    func save(_ state: ConnectionState) -> AnyPublisher<Entity, Error> {
        return add { entity in
            guard let test = entity as? TestResult else {
                return
            }
            test.downloadSpeed = state.downloadSpeed ?? 0
            test.uploadSpeed = state.uploadSpeed ?? 0
            test.timestamp = Date()
        }
    }

}
