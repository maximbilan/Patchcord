//
//  NDT7TestDependency.swift
//  Patchcord
//
//  Created by Maksym Bilan on 19.06.2022.
//

import Foundation
import NDT7

class NDT7TestDependency {
    let test: NDT7Test

    init(delegate: NDT7TestInteraction) {
        test = NDT7Test(settings: NDT7Settings())
        test.delegate = delegate
    }

    func startTest(download: Bool, upload: Bool, _ completion: @escaping (_ error: NSError?) -> Void) {
        test.startTest(download: download, upload: upload, completion)
    }

    func reset() {
        test.delegate = nil
    }

    func cancel() {
        test.cancel()
        reset()
    }

}
