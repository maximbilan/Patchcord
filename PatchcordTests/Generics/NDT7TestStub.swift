//
//  NDT7TestStub.swift
//  PatchcordTests
//
//  Created by Maksym Bilan on 19.06.2022.
//

import Foundation
@testable import Patchcord

final class NDT7TestStub: NDT7TestDependency {

    private var completion: ((_ error: NSError?) -> Void)?

    override func startTest(download: Bool, upload: Bool, _ completion: @escaping (_ error: NSError?) -> Void) {
        self.completion = completion
    }

    override func cancel() {
    }

    func finish() {
        completion?(nil)
    }

}
