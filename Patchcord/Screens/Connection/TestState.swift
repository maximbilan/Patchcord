//
//  TestState.swift
//  Patchcord
//
//  Created by Maksym Bilan on 18.06.2022.
//

import Foundation

enum TestState {
    case notStarted
    case started
    case downloading
    case uploading
    case finished
    case canceled
    case interrupted(Error?)
}
