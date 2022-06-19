//
//  ConnectionMock.swift
//  PatchcordTests
//
//  Created by Maksym Bilan on 19.06.2022.
//

@testable import Patchcord

final class ConnectionMock: ConnectionMiddleware {

    private var latestTest: NDT7TestStub?

    override func createTest() -> NDT7TestDependency {
        let test = NDT7TestStub(delegate: self)
        latestTest = test
        return test
    }

    func finish() {
        latestTest?.finish()
    }

}
