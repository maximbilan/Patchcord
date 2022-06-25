//
//  GatewayMonitor.swift
//  Patchcord
//
//  Created by Maksym Bilan on 25.06.2022.
//

import Combine
import UIKit

final class GatewayMonitor {

    func middleware(state: SceneState, action: Action) -> AnyPublisher<Action, Never> {
        switch action {
            case ConnectionStateAction.startTest:
                find()
            default:
                break
        }
        return Empty().eraseToAnyPublisher()
    }

    private func find() {
        let ipAddress = UIDevice.current.getIP()
        print(ipAddress)
    }

}


extension UIDevice {

    /**
     Returns device ip address. Nil if connected via celluar.
     */
    func getIP() -> String? {

        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?

        if getifaddrs(&ifaddr) == 0 {

            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next } // memory has been renamed to pointee in swift 3 so changed memory to pointee

                guard let interface = ptr?.pointee else {
                    return nil
                }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    guard let ifa_name = interface.ifa_name else {
                        return nil
                    }
                    let name: String = String(cString: ifa_name)

                    if name == "en0" {  // String.fromCString() is deprecated in Swift 3. So use the following code inorder to get the exact IP Address.
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }

                }
            }
            freeifaddrs(ifaddr)
        }

        return address
    }

}
