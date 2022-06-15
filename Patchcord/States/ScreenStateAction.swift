//
//  ScreenStateAction.swift
//  Patchcord
//
//  Created by Maksym Bilan on 15.06.2022.
//

import Foundation

enum ScreenStateAction: Action {
    case show(ScreenState)
    case dismiss(ScreenState)
}
