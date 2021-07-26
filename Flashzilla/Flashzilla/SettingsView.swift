//
//  SettingsView.swift
//  Flashzilla
//
//  Created by Tim Musil on 26.07.21.
//

import SwiftUI

struct SettingsView: View {
    @Binding var repeatCards: Bool
    var body: some View {
        Form {
            Toggle(isOn: $repeatCards) {
                Text("Repeat Unknown Cards")
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(repeatCards: .constant(false))
    }
}
