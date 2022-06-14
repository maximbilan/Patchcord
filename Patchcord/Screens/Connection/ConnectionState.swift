//
//  ConnectionState.swift
//  Patchcord
//
//  Created by Maksym Bilan on 13.06.2022.
//

import Foundation

struct ConnectionState {
    let isTesting: Bool
}

extension ConnectionState {
    init() {
        isTesting = false
    }
}
