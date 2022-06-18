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
            guard let test = entity as? Test else {
                return
            }
            test.downloadResult = state.downloadSpeed ?? 0
            test.uploadResult = state.uploadSpeed ?? 0
            test.timestamp = Date()
        }
    }

}
