//
//  ParentChildExampleApp.swift
//  ParentChildExample
//
//  Created by Jonny Sagorin on 24/7/21.
//

import SwiftUI

@main
struct ParentChildExampleApp: App {
    let persistenceController = PersistenceController.preview

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
