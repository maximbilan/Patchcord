//
//  ConnectionViewLabel.swift
//  Patchcord
//
//  Created by Maksym Bilan on 17.08.2023.
//

import SwiftUI

struct GroupLabelView: View {
    let left: String
    let right: String

    var body: some View {
        HStack {
            Text(left)
                .multilineTextAlignment(.leading)
            Spacer()
            Text(right)
                .multilineTextAlignment(.trailing)
        }
    }
}
