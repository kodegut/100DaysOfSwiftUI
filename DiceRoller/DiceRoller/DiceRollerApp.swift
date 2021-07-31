//
//  DiceRollerApp.swift
//  DiceRoller
//
//  Created by Tim Musil on 31.07.21.
//

import SwiftUI

@main
struct DiceRollerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
