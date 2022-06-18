//
//  ScreenStateAction.swift
//  Patchcord
//
//  Created by Maksym Bilan on 15.06.2022.
//

import Foundation

enum Screen {
    case connection
    case history
}

enum ScreenStateAction: Action {
    case show(Screen)
    case dismiss(Screen)
}
