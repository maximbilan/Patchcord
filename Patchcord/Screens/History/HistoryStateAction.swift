//
//  HistoryStateAction.swift
//  Patchcord
//
//  Created by Maksym Bilan on 17.06.2022.
//

import Foundation

enum HistoryStateAction: Action {
    case fetchHistory
    case didReceiveTests([Test])
}
