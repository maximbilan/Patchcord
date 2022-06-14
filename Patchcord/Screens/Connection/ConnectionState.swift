//
//  ConnectionState.swift
//  Patchcord
//
//  Created by Maksym Bilan on 13.06.2022.
//

import Foundation

enum ConnectionState {
    case notStarted
    case started
    case downloading
    case uploading
    case finished
    case canceled
    case interrupted(Error?)
}
