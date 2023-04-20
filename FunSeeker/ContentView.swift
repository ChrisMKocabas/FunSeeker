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
  @EnvironmentObject var viewModel: AuthenticationViewModel
  @StateObject var eventViewModel = EventViewModel()
  @EnvironmentObject var presentingProfileScreen: ProfileScreenState

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>

  @State private var navSelection = 0


  private var navbarTitles:[String] = ["Events Near You","Your Favourites","Saved Events"]

  var body: some View {

      NavigationStack{
        ZStack{
          TabView(selection:$navSelection) {

            EventsView(eventViewModel:eventViewModel)
              .tabItem {
                Label("Upcoming", systemImage: "figure.socialdance")
              }.tag(0)

            FavouriteEventsView(eventViewModel:eventViewModel)
              .tabItem {
                Label("Favourites", systemImage: "heart")
              }.tag(1)

            SavedEventsView(eventViewModel:eventViewModel)
              .tabItem {
                Label("Saved", systemImage: "calendar")
              }.tag(2)

          }
        }
        .toolbar {
          ToolbarItem (placement: .navigationBarTrailing){
            NavigationLink(
              destination: UserProfileView(),
              label: {
                Image(systemName: "person.crop.circle")
              }).environmentObject(viewModel)
          }

          ToolbarItem(placement: .navigationBarLeading) {
            Text("\(navbarTitles[navSelection])")
              .fontWeight(.bold)
              .font(.custom("System",size:20,relativeTo:.title))
          }
        }

//      .onAppear(){
//        Task{
//          await eventViewModel.getData()
//        }
//      }
    }



  }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AuthenticationViewModel())
    }
}
