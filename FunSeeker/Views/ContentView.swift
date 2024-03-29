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
  @StateObject var savedEventsViewModel = SavedEventsViewModel()
  @StateObject var favouritesViewModel = FavouritesViewModel()
  @EnvironmentObject var presentingProfileScreen: ProfileScreenState

  @StateObject var networkManager = NetworkManager()
  @StateObject var localFileManager = LocalFileManager()

  // Fetching results from Core Data
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>

  // Shared information among views
  @StateObject var sharedInformation = SharedInfo()

  // Titles for the navigation bar
  private var navbarTitles:[String] = ["Events Near You","Your Favourites","Saved Events","Profile"]

  var body: some View {

    TabView(selection:$sharedInformation.currentTab) {
      NavigationStack{
        EventsView(eventViewModel:eventViewModel, savedEventsViewModel:savedEventsViewModel, favouritesViewModel:favouritesViewModel, networkManager:networkManager,localFileManager:localFileManager)
          .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
              // Title for the navigation bar
              Text("\(navbarTitles[sharedInformation.currentTab])")
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundColor(Color.black)
            }
            ToolbarItem(placement: .navigationBarTrailing){
              // Logo for the navigation bar
              Image("app-logo")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 150, maxHeight: 80, alignment:.top)
                .clipped()
                .opacity(0.2)
            }
          }
          .toolbarBackground(Color(red: 1, green: 0.3157, blue: 0.3333), for: .navigationBar)

      }
      .tabItem {
        // Tab item for the "Upcoming" tab
        Label("Upcoming", systemImage: "figure.socialdance")
      }.tag(0)
      .toolbarBackground(Color(red: 0.9529, green: 0.7176, blue: 0.2431), for: .tabBar)



      NavigationStack{
        FavouriteEventsView(eventViewModel:eventViewModel, favouritesViewModel: favouritesViewModel, savedEventsViewModel: savedEventsViewModel)
          .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
              // Title for the navigation bar
              Text("\(navbarTitles[sharedInformation.currentTab])")
                .font(.system(size: 20, weight: .heavy, design: .rounded))
            }
          }
      }
      .tabItem {
        // Tab item for the "Favourites" tab
        Label("Favourites", systemImage: "heart")
      }.tag(1)
      .toolbarBackground(Color(red: 0.9529, green: 0.7176, blue: 0.2431), for: .tabBar)

      NavigationStack{
        SavedEventsView(eventViewModel:eventViewModel, savedEventsViewModel:savedEventsViewModel)
          .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
              // Title for the navigation bar
              Text("\(navbarTitles[sharedInformation.currentTab])")
                .font(.system(size: 20, weight: .heavy, design: .rounded))
            }
          }
      }
      .tabItem {
        // Tab item for the "Saved" tab
        Label("Saved", systemImage: "calendar")
      }.tag(2)
      .toolbarBackground(Color(red: 0.9529, green: 0.7176, blue: 0.2431), for: .tabBar)

      NavigationStack{
        UserProfileView()
          .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
              // Title for the navigation bar
              Text("\(navbarTitles[sharedInformation.currentTab])")
                .font(.system(size: 20, weight: .heavy, design: .rounded))
            }

          }
      }
      .tabItem {
        // Tab item for the "Profile" tab
        Label("Profile", systemImage: "person.crop.circle")
      }.tag(3)
      .toolbarBackground(Color(red: 0.9529, green: 0.7176, blue: 0.2431), for: .tabBar)

    }
    .background(Color.clear)
    .tint(Color.black)
    .environmentObject(sharedInformation)
    // .environmentObject(networkManager)
    .environmentObject(localFileManager)

  }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AuthenticationViewModel())
    }
}


class SharedInfo: ObservableObject {
  @Published var currentTab: Int = 0
}
