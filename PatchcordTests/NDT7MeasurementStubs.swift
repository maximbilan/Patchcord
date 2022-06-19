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
   "ElapsedTime": 12341,
   "NumBytes": 12342,
 },
 "BBRInfo": {
   "ElapsedTime": 123,
   "BW": 456,
   "MinRTT": 789,
   "CwndGain":739,
   "PacingGain":724
 },
"ConnectionInfo": {
  "Client": "1.2.3.4:5678",
  "Server": "[::1]:2345",
  "UUID": "<platform-specific-string>"
},
 "Origin": "server",
 "Test": "download",
 "TCPInfo": {
   "BusyTime": 1234,
   "BytesAcked": 12345,
   "BytesReceived": 12346,
   "BytesSent": 12347,
   "BytesRetrans": 12348,
   "ElapsedTime": 12349,
   "MinRTT": 12340,
   "RTT": 123411,
   "RTTVar": 123412,
   "RWndLimited": 123413,
   "SndBufLimited": 123414
 }
}
"""

    static let uploadMeasurementJSON = """
{
 "AppInfo": {
   "ElapsedTime": 12341,
   "NumBytes": 12342,
 },
 "BBRInfo": {
   "ElapsedTime": 123,
   "BW": 456,
   "MinRTT": 789,
   "CwndGain":739,
   "PacingGain":724
 },
"ConnectionInfo": {
  "Client": "1.2.3.4:5678",
  "Server": "[::1]:2345",
  "UUID": "<platform-specific-string>"
},
 "Origin": "server",
 "Test": "upload",
 "TCPInfo": {
   "BusyTime": 1234,
   "BytesAcked": 12345,
   "BytesReceived": 12346,
   "BytesSent": 12347,
   "BytesRetrans": 12348,
   "ElapsedTime": 12349,
   "MinRTT": 12340,
   "RTT": 123411,
   "RTTVar": 123412,
   "RWndLimited": 123413,
   "SndBufLimited": 123414
 }
}
"""

}
