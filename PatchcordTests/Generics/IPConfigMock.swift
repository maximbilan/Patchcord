//
//  IPConfigMock.swift
//  PatchcordTests
//
//  Created by Maksym Bilan on 26.06.2022.
//

import Foundation
@testable import Patchcord

final class IPConfigMock: IPConfig {

    override func getPublicIP(completion: @escaping (String?) -> Void) {
        completion("8.8.8.8")
    }

}
