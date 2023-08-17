//
//  RootView.swift
//  Patchcord
//
//  Created by Maksym Bilan on 12.06.2022.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView {
            ConnectionView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
