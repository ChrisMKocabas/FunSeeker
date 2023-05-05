//
//  EventsView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-19.
//

import SwiftUI


struct EventsView: View {

  @ObservedObject var eventViewModel: EventViewModel
  @ObservedObject var firestoreManager: FirestoreManager
  @State private var searchText = ""
  @State private var filtering = false
  @State private var filteredEvents = [Event]()

  var body: some View {
    let backgroundGradient = LinearGradient(
      colors: [Color.blue, Color.green],
      startPoint: .top, endPoint: .bottom)


    let columns:[GridItem] = [
      GridItem(.flexible(), spacing: 2,alignment: nil),
      GridItem(.flexible(), spacing: 2,alignment: nil)

    ]

    NavigationStack{
      ZStack {
        backgroundGradient.ignoresSafeArea()
        ScrollView(showsIndicators: false){
          
          ZStack{
            Image("banner")
              .resizable()
              .scaledToFill()
              .frame(maxWidth: .infinity, maxHeight: 240)
              .clipped()
              .blur(radius: 15)
              .padding(.bottom,20)
            
            Image("banner")
              .resizable()
              .scaledToFill()
              .frame(maxWidth: .infinity, maxHeight: 200)
              .clipped()
          }
          LazyVGrid(columns:columns) {
            ForEach(filtering ? filteredEvents : eventViewModel.events, id:\.self.id) {item in
              NavigationLink(value: item) {
                VStack{
                  AsyncImage(url:URL(string: item.images[0].url.replacingOccurrences(of: "http://", with: "https://"))) { phase in
                    switch phase {
                    case .empty:
                      ProgressView()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 150, maxHeight: 100)
                        .clipShape(Ellipse()) // Add this line to clip to a circle
                    case .success(let image):
                      image
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 150,maxHeight: 250)
                        .clipped()
                        .cornerRadius(10)
                      
                    case .failure(_):
                      Image("banner")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 150,maxHeight: 100)
                        .clipShape(Ellipse())
                    @unknown default:
                      EmptyView()
                    }
                  }
                  VStack(alignment: .center, spacing: 10){
                    Text(item.name)
                    Text(item.innerembedded?.venues[0].name ?? "")
                    Text(item.dates.start.localDate)
                  }.foregroundColor(Color.black)
                }
                
              }
              .frame(maxWidth: .infinity, maxHeight: 400)
              
              .background(Color.random().opacity(0.1))
              .padding(.vertical,10)
              
              
              .onAppear(perform:{
                if eventViewModel.shouldLoadMoreData(id: item.id){
                  Task{
                    await eventViewModel.fetchMoreEvents()
                  }
                }
              })
            }.border(Color.gray.opacity(0.4))
              .padding(4)
            
            
          }
        }.navigationDestination(for: Event.self, destination: { item in
          EventView(eventViewModel:eventViewModel, firestoreManager:firestoreManager, item:[item])
        })
        .onAppear(){
          Task{
            await eventViewModel.getData()
            
          }
          
        }
      }
      .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always), prompt: "Looking for an event?") { ForEach(searchResults, id: \.self){ result in
        Text("Are you looking for \(result)?").searchCompletion(result)
      }}
    }
  }

  var searchResults: [String] {
      if searchText.isEmpty {
        DispatchQueue.main.async{
          filtering = false
        }
        return []
      } else {
        filtering = true
        filteredEvents = eventViewModel.events.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        return eventViewModel.events.filter { $0.name.lowercased().contains(searchText.lowercased()) } .map { $0.name }
      }
  }
}

struct EventsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack{
      EventsView(eventViewModel: EventViewModel(),firestoreManager: FirestoreManager())
    }
    
  }
}
public extension Color {

    static func random(randomOpacity: Bool = false) -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: randomOpacity ? .random(in: 0...1) : 1
        )
    }
}
