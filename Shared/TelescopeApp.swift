//
//  TelescopeApp.swift
//  Shared
//
//  Created by Linus Skucas on 8/18/21.
//

import SwiftUI

@main
struct TelescopeApp: App {
    let persistenceController = PersistenceController.shared  // TODO: Remove this (see wwdc video)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .frame(minWidth: 900, minHeight: 500) TODO FIX THIS SO WE CAN HAVE A MIN VALUES ON MACOS
        }
    }
}
