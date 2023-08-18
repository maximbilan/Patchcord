//
//  ConnectionStateAction.swift
//  Patchcord
//
//  Created by Maksym Bilan on 13.06.2022.
//

import Foundation

enum ConnectionStateAction: Action {
    case startTest
    case cancelTest
    case refreshScreen(ConnectionState)
    case saveResults(ConnectionState)
}

extension ConnectionStateAction {

    var animated: Bool {
        false
    }

}
