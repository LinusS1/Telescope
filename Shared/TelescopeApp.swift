//
//  TelescopeApp.swift
//  Shared
//
//  Created by Linus Skucas on 8/18/21.
//

import SwiftUI

@main
struct TelescopeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
