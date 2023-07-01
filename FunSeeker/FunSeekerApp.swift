//
//  FunSeekerApp.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-09.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

// AppDelegate class to handle Firebase configuration during app launch
class AppDelegate: NSObject, UIApplicationDelegate {
  // Function called when the application finishes launching
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // Configure Firebase
    FirebaseApp.configure()

    return true
  }
}

// Main App struct for the FunSeeker app
@main
struct FunSeekerApp: App {

  // Use the AppDelegate to configure Firebase during app launch
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  // Initialize the PersistenceController for Core Data management
  let persistenceController = PersistenceController.shared

  // Main entry point for the app's UI
  var body: some Scene {
    // WindowGroup represents the main app window
    WindowGroup {
      // Wrap the ContentView inside AuthenticatedView, which handles authentication state
      AuthenticatedView {
        ContentView()
          .environment(\.managedObjectContext, persistenceController.container.viewContext)
      }
    }
  }
}
