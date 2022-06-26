//
//  PingManagerMock.swift
//  PatchcordTests
//
//  Created by Maksym Bilan on 26.06.2022.
//

import Foundation
@testable import Patchcord

final class PingManagerMock: PingManager {

    override func start() {
        let result = PingResult(ping: 0.002, jitter: 0.0001, packetLoss: 1)
        delegate?.pingDidFinish(result)
    }

}
