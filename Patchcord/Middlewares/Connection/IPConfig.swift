//
//  IPConfig.swift
//  Patchcord
//
//  Created by Maksym Bilan on 26.06.2022.
//

import SwiftIPConfig
import SwiftPublicIP

final class IPConfig {

    func getIP() -> String? {
        SwiftIPConfig.getIP()
    }

    func getGatewayIP() -> String? {
        SwiftIPConfig.getGatewayIP()
    }

    func getNetmask() -> String? {
        SwiftIPConfig.getNetmask()
    }

    func getPublicIP(completion: @escaping (String?) -> Void) {
        SwiftPublicIP.getPublicIP(url: PublicIPAPIURLs.hybrid.icanhazip.rawValue) { (string, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            completion(string)
        }
    }

}
