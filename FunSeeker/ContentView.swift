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

  @StateObject var sharedInformation = SharedInfo()


  private var navbarTitles:[String] = ["Events Near You","Your Favourites","Saved Events","Profile"]

  var body: some View {

    TabView(selection:$sharedInformation.currentTab) {
          NavigationStack{
            EventsView(eventViewModel:eventViewModel, firestoreManager:firestoreManager)
              .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                  Text("\(navbarTitles[sharedInformation.currentTab])")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundColor(Color.black)
               

                }
              }
              .toolbarBackground(Color(red: 1, green: 0.3157, blue: 0.3333), for: .navigationBar)

          }
            .tabItem {
              Label("Upcoming", systemImage: "figure.socialdance")
            }.tag(0)
            .toolbarBackground(Color(red: 0.9529, green: 0.7176, blue: 0.2431), for: .tabBar)
          


          NavigationStack{
            FavouriteEventsView(eventViewModel:eventViewModel, firestoreManager: firestoreManager)
              .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                  Text("\(navbarTitles[sharedInformation.currentTab])")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                }
              }
          }
            .tabItem {
              Label("Favourites", systemImage: "heart")
            }.tag(1)
            .toolbarBackground(Color(red: 0.9529, green: 0.7176, blue: 0.2431), for: .tabBar)

          NavigationStack{
            SavedEventsView(eventViewModel:eventViewModel, firestoreManager:firestoreManager)
              .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                  Text("\(navbarTitles[sharedInformation.currentTab])")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                }
              }
          }
            .tabItem {
              Label("Saved", systemImage: "calendar")
            }.tag(2)
            .toolbarBackground(Color(red: 0.9529, green: 0.7176, blue: 0.2431), for: .tabBar)

          NavigationStack{
            UserProfileView()
              .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                  Text("\(navbarTitles[sharedInformation.currentTab])")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                }
              }
          }
            .tabItem {
              Label("Profile", systemImage: "person.crop.circle")
            }.tag(3)
            .toolbarBackground(Color(red: 0.9529, green: 0.7176, blue: 0.2431), for: .tabBar)

          

        }.background(Color.clear)
          .tint(Color.black)
          .environmentObject(sharedInformation)

  }


}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AuthenticationViewModel())
    }
}


class SharedInfo:ObservableObject {

  @Published var currentTab:Int = 0
}
