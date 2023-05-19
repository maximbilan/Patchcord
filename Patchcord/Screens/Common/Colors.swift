//
//  Colors.swift
//  Patchcord
//
//  Created by Maksym Bilan on 19.05.2023.
//

import SwiftUI

extension Color {
    static let topBackground: Color = Color(hex: 0x18002D)
    static let bottomBackground: Color = Color(hex: 0x540252)
    static let button = Color(hex: 0xFFA981)
    static let label: Color = Color(hex: 0x540252)
}

extension Color {

    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }

}
