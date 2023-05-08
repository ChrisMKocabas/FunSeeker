//
//  SavedEventsView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-19.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SavedEventsView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @ObservedObject var eventViewModel: EventViewModel
  @ObservedObject var firestoreManager: FirestoreManager
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>
  
  @State private var filtering = false
  @State private var filteredEvents = [Event]()
  
  var body: some View {
    VStack {
      if (firestoreManager.userEvents.count>0) {
        List{
          ForEach(filtering ? filteredEvents : firestoreManager.userEvents, id:\.self.id) {item in
            NavigationLink(value: item) {
              HStack(alignment: .center, spacing: 10){
                AsyncImage(url:URL(string: item.images[0].url.replacingOccurrences(of: "http://", with: "https://"))) { phase in
                  switch phase {
                  case .empty:
                    ProgressView()
                      .aspectRatio(contentMode: .fit)
                      .frame(maxWidth: 150, maxHeight: 150)
                      .clipShape(Circle()) // Add this line to clip to a circle
                  case .success(let image):
                    image
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(minWidth: 80, idealWidth: 150, maxWidth: 150, minHeight: 80, idealHeight: 150, maxHeight: 150, alignment: .center)
                      .clipShape(Circle()) // Add this line to clip to a circle
                    
                    
                  case .failure(_):
                    Image("banner")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(maxWidth: 150,maxHeight: 150)
                      .clipShape(Circle())
                  @unknown default:
                    EmptyView()
                  }
                }
                VStack(alignment: .leading, spacing: 10){
                  Text(item.name)
                  Text(item.innerembedded?.venues[0].name ?? "")
                  Text(item.dates.start.localDate)
                }.foregroundColor(Color.black)
              }
              
            }.frame(maxWidth: .infinity, maxHeight: 200)
              .background(Color.random().opacity(0.2).blur(radius: 30))
            
//              .onAppear(perform:{
//                if eventViewModel.shouldLoadMoreData(id: item.id){
//                  Task{
//                    await firestoreManager.fetchUserEvents()
//                  }
//                }
//              })
          }.onDelete { IndexSet in
            deleteItems(offsets: IndexSet)
          }   .padding(.vertical)
          
          
          
        }.navigationDestination(for: Event.self, destination: { item in
          EventView(eventViewModel:eventViewModel, firestoreManager: firestoreManager, item:[item])
        })
        .frame( maxWidth: .infinity)
        .edgesIgnoringSafeArea(.horizontal)
        .listStyle(GroupedListStyle())
        
      } else {
        Text("No Favourites Yet!")
      }
    }
    .onAppear(){
      Task{
        await firestoreManager.fetchUserEvents()
      }
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        EditButton()
      }

    }
    
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {

      let sortedIndexes = Array(offsets).sorted()
      
      var event: Event?
      
      // Remove each item at the selected indexes from the userPhotos array
      for index in sortedIndexes.reversed() {
        event = firestoreManager.userEvents.remove(at: index)
      }
      print("\(event!.id)")
      
      let user = Auth.auth().currentUser
      let db = Firestore.firestore()
      let docRef = db.collection("users").document(user!.uid).collection("events").document("\(event!.id)")
      docRef.delete { error in
        if error != nil {
          print("error deleting from firebase firestore")
        } else {
          print("image deleted successfully from firestore")
        }
      }
    }
    
  }
}

//private let itemFormatter: DateFormatter = {
//  let formatter = DateFormatter()
//  formatter.dateStyle = .short
//  formatter.timeStyle = .medium
//  return formatter
//}()


struct SavedEventsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack{
      SavedEventsView(eventViewModel: EventViewModel(),firestoreManager: FirestoreManager())
    }
  }
}
