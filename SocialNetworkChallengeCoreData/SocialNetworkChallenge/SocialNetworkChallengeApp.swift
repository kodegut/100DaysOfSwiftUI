//
//  SocialNetworkChallengeApp.swift
//  SocialNetworkChallenge
//
//  Created by Tim Musil on 17.06.21.
//

import SwiftUI

@main
struct SocialNetworkChallengeApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
