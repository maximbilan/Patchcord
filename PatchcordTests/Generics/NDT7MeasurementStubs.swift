//
//  NDT7MeasurementStubs.swift
//  PatchcordTests
//
//  Created by Maksym Bilan on 19.06.2022.
//

import Foundation
import NDT7

extension NDT7Measurement {

    static func measurement(from JSON: String) -> NDT7Measurement {
        return try! JSONDecoder().decode(NDT7Measurement.self, from: JSON.data(using: .utf8)!)
    }

    static let downloadMeasurementJSON = """
{
 "AppInfo": {
   "ElapsedTime": 123410000,
   "NumBytes": 123420000,
 },
 "BBRInfo": {
   "ElapsedTime": 12300000,
   "BW": 4560000,
   "MinRTT": 7890000,
   "CwndGain":7390000,
   "PacingGain":7240000
 },
"ConnectionInfo": {
  "Client": "1.2.3.4:5678",
  "Server": "[::1]:2345",
  "UUID": "<platform-specific-string>"
},
 "Origin": "server",
 "Test": "download",
 "TCPInfo": {
   "BusyTime": 12340000,
   "BytesAcked": 123450000,
   "BytesReceived": 123460000,
   "BytesSent": 123470000,
   "BytesRetrans": 123480000,
   "ElapsedTime": 123490000,
   "MinRTT": 123400000,
   "RTT": 1234110000,
   "RTTVar": 1234120000,
   "RWndLimited": 1234130000,
   "SndBufLimited": 1234140000
 }
}
"""

    static let uploadMeasurementJSON = """
{
 "AppInfo": {
   "ElapsedTime": 1234100000,
   "NumBytes": 1234200000,
 },
 "BBRInfo": {
   "ElapsedTime": 12300000,
   "BW": 45600000,
   "MinRTT": 78000009,
   "CwndGain":73900000,
   "PacingGain":72400000
 },
"ConnectionInfo": {
  "Client": "1.2.3.4:5678",
  "Server": "[::1]:2345",
  "UUID": "<platform-specific-string>"
},
 "Origin": "client",
 "Test": "upload",
 "TCPInfo": {
   "BusyTime": 123400000,
   "BytesAcked": 1234500000,
   "BytesReceived": 9877300000,
   "BytesSent": 9878300000,
   "BytesRetrans": 1234800000,
   "ElapsedTime": 1234900000,
   "MinRTT": 1234000000,
   "RTT": 12341100000,
   "RTTVar": 12341200000,
   "RWndLimited": 12341300000,
   "SndBufLimited": 12341400000
 }
}
"""

}
