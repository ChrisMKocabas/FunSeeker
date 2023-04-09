//
//  FunSeekerApp.swift
//  FunSeeker
//
//  Created by Muhammed Kocabas on 2023-04-09.
//

import SwiftUI

@main
struct FunSeekerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
