//
//  ContentView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-09.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @StateObject var eventViewModel = EventViewModel()
  @StateObject var firestoreManager = FirestoreManager()
  @EnvironmentObject var presentingProfileScreen: ProfileScreenState

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>

  @State private var navSelection = 0


  private var navbarTitles:[String] = ["Events Near You","Your Favourites","Saved Events","Profile"]

  var body: some View {

        TabView(selection:$navSelection) {

          NavigationStack{
            EventsView(eventViewModel:eventViewModel, firestoreManager:firestoreManager)
              .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                  Text("\(navbarTitles[navSelection])")
                    .fontWeight(.bold)
                    .font(.custom("System",size:20,relativeTo:.title))
                }
              }
          }
            .tabItem {
              Label("Upcoming", systemImage: "figure.socialdance")
            }.tag(0)

          NavigationStack{
            FavouriteEventsView(eventViewModel:eventViewModel)
              .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                  Text("\(navbarTitles[navSelection])")
                    .fontWeight(.bold)
                    .font(.custom("System",size:20,relativeTo:.title))
                }
              }
          }
            .tabItem {
              Label("Favourites", systemImage: "heart")
            }.tag(1)

          NavigationStack{
            SavedEventsView(eventViewModel:eventViewModel, firestoreManager:firestoreManager)
              .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                  Text("\(navbarTitles[navSelection])")
                    .fontWeight(.bold)
                    .font(.custom("System",size:20,relativeTo:.title))
                }
              }
          }
            .tabItem {
              Label("Saved", systemImage: "calendar")
            }.tag(2) 

          NavigationStack{
            UserProfileView()
              .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                  Text("\(navbarTitles[navSelection])")
                    .fontWeight(.bold)
                    .font(.custom("System",size:20,relativeTo:.title))
                }
              }
          }
            .tabItem {
              Label("Profile", systemImage: "person.crop.circle")
            }.tag(3)

        }.background(Color.clear)

    }


}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AuthenticationViewModel())
    }
}
