//
//  GatewayMonitor.swift
//  Patchcord
//
//  Created by Maksym Bilan on 25.06.2022.
//

import Combine
import UIKit
import Gateway

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
        if let gateway = getGatewayIP() {
            print(gateway)
        }
        if let ipAddress = UIDevice.current.getIP() {
            print(ipAddress)
        }
        print(getIfaNetmask())
    }

}

func getGatewayIP() -> String? {
    var gatewayaddr = in_addr()
    let r = getdefaultgateway(&gatewayaddr.s_addr)
    if r >= 0 {
        return String(cString: inet_ntoa(gatewayaddr))
    } else {
        return nil
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

func getIfaNetmask() -> String {
    var ifaNetmask = ""
    //Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {

        var ptr = ifaddr;
        while ptr != nil {
            let name = String.init(utf8String: ptr!.pointee.ifa_name)  //[NSString stringWithUTF8String:ptr->ifa_name];
            if (name == "en0")
            {
            let flags = Int32((ptr?.pointee.ifa_flags)!)
            var addr = ptr?.pointee.ifa_addr.pointee

            //Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6) {

                    //Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr!, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        if let address = String.init(validatingUTF8:hostname) {

                            var net = ptr?.pointee.ifa_netmask.pointee
                            var netmaskName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            getnameinfo(&net!, socklen_t((net?.sa_len)!), &netmaskName, socklen_t(netmaskName.count),
                                        nil, socklen_t(0), NI_NUMERICHOST)//== 0
                            if let netmask = String.init(validatingUTF8:netmaskName) {
                                print("address=/(address),netmask\(netmask)")
                                ifaNetmask = netmask
                            }
                        }
                    }
                }
            }
            }
            ptr = ptr?.pointee.ifa_next
        }
        freeifaddrs(ifaddr)
    }
    return ifaNetmask
}
