//
//  NDT7Bridge.swift
//  Patchcord
//
//  Created by Maksym Bilan on 11.06.2022.
//

import UIKit
import NDT7

class NDT7Bridge {

    var ndt7Test: NDT7Test?

    init() {
        NDT7.loggingEnabled = true
    }

    func startTest() {
        // 2. Create the settings for testing. NDT7Settings.
        let settings = NDT7Settings()
        // 3. Create a NDT7Test object with NDT7Settings already created.
        ndt7Test = NDT7Test(settings: settings)
        // 4. Setup a delegation for NDT7Test to get the test information.
        ndt7Test?.delegate = self
        // 5. Start speed test for download and/or upload.
        ndt7Test?.startTest(download: true, upload: true) { [weak self] (error) in
            guard self != nil else { return }
            if let error = error {
                print("NDT7 iOS Example app - Error during test: \(error.localizedDescription)")
            } else {
                print("NDT7 iOS Example app - Test finished.")
            }
        }
    }

    func cancelTest() {
        ndt7Test?.cancel()
    }

}

extension NDT7Bridge: NDT7TestInteraction {

    func test(kind: NDT7TestConstants.Kind, running: Bool) {
    }

    func measurement(origin: NDT7TestConstants.Origin, kind: NDT7TestConstants.Kind, measurement: NDT7Measurement) {
        
    }

    func error(kind: NDT7TestConstants.Kind, error: NSError) {
    }
}
