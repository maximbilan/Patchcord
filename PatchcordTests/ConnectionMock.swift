//
//  ConnectionMock.swift
//  PatchcordTests
//
//  Created by Maksym Bilan on 19.06.2022.
//

@testable import Patchcord

final class ConnectionMock: ConnectionMiddleware {

    override func createTest() -> NDT7TestDependency {
        NDT7TestDependency(delegate: self)
    }

}
