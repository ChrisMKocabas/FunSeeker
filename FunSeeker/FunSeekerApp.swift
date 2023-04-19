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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct FunSeekerApp: App {

  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
          NavigationView{
            AuthenticatedView{
              ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

            }

          }
        }
    }
}
