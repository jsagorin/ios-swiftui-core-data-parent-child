//
//  ParentChildExampleApp.swift
//  ParentChildExample
//
//  Created by Jonny Sagorin on 24/7/21.
//

import SwiftUI

@main
struct ParentChildExampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
