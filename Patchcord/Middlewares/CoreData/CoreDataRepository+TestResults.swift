//
//  CoreDataRepository+TestResults.swift
//  Patchcord
//
//  Created by Maksym Bilan on 17.06.2022.
//

import Foundation
import Combine

extension CoreDataRepository {

    func save(_ result: ConnectionTestResult) -> AnyPublisher<Entity, Error> {
        return add { entity in
            guard let test = entity as? Test else {
                return
            }
            test.downloadResult = result.downloadSpeed
            test.uploadResult = result.uploadSpeed
            test.timestamp = Date()
        }
    }

}
