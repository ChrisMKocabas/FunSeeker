//
//  EventsView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-19.
//

import SwiftUI


struct EventsView: View {

  @ObservedObject var eventViewModel: EventViewModel
  @ObservedObject var savedEventsViewModel: SavedEventsViewModel
  @ObservedObject var favouritesViewModel: FavouritesViewModel
  @State private var searchText = ""
  @State private var filteredEvents = [Event]()
  @State private var toolbarVisibility : Visibility = .hidden
  @ObservedObject var networkManager:NetworkManager
  @ObservedObject var localFileManager: LocalFileManager
  

  let backgroundGradient = LinearGradient(
      colors: [Color.pink, Color.yellow],
      startPoint: .top, endPoint: .bottom)


  let columns:[GridItem] = [
    GridItem(.flexible(), spacing: 2,alignment: nil),
//    GridItem(.flexible(), spacing: 2,alignment: nil)

  ]

  var body: some View {
    VStack{
      ZStack {
        backgroundGradient.ignoresSafeArea()
        if (networkManager.isActive == true) {
          ScrollView(showsIndicators: false){
            LazyVGrid(columns:columns) {
              ForEach(eventViewModel.events, id:\.self.id) {item in
                ExtractedView(item:item)
                  .frame(maxWidth: .infinity,idealHeight: 400, maxHeight: 600)
                  .onAppear(perform:{
                    if eventViewModel.shouldLoadMoreData(id: item.id){
                      Task{
                        await eventViewModel.fetchMoreEvents()
                      }
                    }
                  })
              } .overlay(
                RoundedRectangle(cornerRadius: 30)
                  .stroke(Color.white, lineWidth:1)
              )
              .padding(10)
            }

          }.refreshable {
            print("Hello world")
          }
          .onAppear(){
            Task{
              if eventViewModel.events.isEmpty && networkManager.isActive {
                await eventViewModel.getData()
                localFileManager.loadOfflineEvents(eventType: .mainfeed)
              }

            }
          }
          .onChange(of: eventViewModel.events) { newValue in
            Task {
              localFileManager.saveEventFeed(events: newValue)
              localFileManager.loadOfflineEvents(eventType: .mainfeed)
            }
          }

        } else {
          ScrollView(showsIndicators: false){

            LazyVGrid(columns:columns) {

              Text("No internet connection.")
              ForEach(localFileManager.offlineEvents, id:\.self.id) {item in
                ExtractedView(item:item)
                  .frame(maxWidth: .infinity,idealHeight: 400, maxHeight: 600)
              } .overlay(
                RoundedRectangle(cornerRadius: 30)
                  .stroke(Color.white, lineWidth:1)
              )
              .padding(10)

            }

          }
        }
      }
      .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always), prompt: "Looking for an event?") {
        ZStack{
          ScrollView {
            LazyVGrid(columns:columns) {
              ForEach(eventViewModel.suggestions, id: \.self.id){ result in
                ExtractedView(item:result)
                  .searchCompletion(result)
              }.background(Color.black.opacity(0.2))
                .cornerRadius(30, corners: .allCorners)
                .padding()
            }
          }
        }
      }
        .onChange(of: searchText) { value in
          Task {
            if value.count >= 3 {
              eventViewModel.suggestionTerm = value
              await eventViewModel.fetchSuggestions()
            }
            else {
              eventViewModel.suggestions = []
            }
          }
        }
        .onSubmit(of: .search){
          Task{
            eventViewModel.suggestionTerm = ""
            eventViewModel.suggestions = []
          }
        }

      

   }.navigationDestination(for: Event.self, destination: { item in
     EventView(eventViewModel:eventViewModel, savedEventsViewModel:savedEventsViewModel,favouritesViewModel:favouritesViewModel, item:[item])
       .navigationBarTitleDisplayMode (.inline)
//       .transaction {
//         $0.animation = .default.speed(4)
//       }
   })
  }
}

struct EventsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack{
      EventsView(eventViewModel: EventViewModel(),savedEventsViewModel: SavedEventsViewModel(), favouritesViewModel: FavouritesViewModel()
                 ,networkManager: NetworkManager(), localFileManager: LocalFileManager())
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

struct ExtractedView: View {

  let item: Event
  var body: some View {
    NavigationLink(value: item) {
      VStack{

        AsyncImage(url:URL(string: item.images[0].url.replacingOccurrences(of: "http://", with: "https://"))) { phase in
          switch phase {
          case .empty:
            ProgressView()
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: .infinity,maxHeight: 250)
              .clipShape(RoundedRectangle(cornerRadius: 30))
          case .success(let image):
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(maxWidth: .infinity, maxHeight: 200)
              .clipShape(RoundedRectangle(cornerRadius: 30))

          case .failure(_):
            Image("banner")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: .infinity,maxHeight: 250)
              .clipShape(RoundedRectangle(cornerRadius: 30))
          @unknown default:
            EmptyView()
          }
        }.overlay(
          RoundedRectangle(cornerRadius: 30)
            .stroke(Color.white, lineWidth:2)
      )
        Spacer()
        VStack(alignment: .leading, spacing: 10){
          Text(item.name).multilineTextAlignment(.leading).fontWeight(.bold)
          HStack(alignment: .top){
            Text("Venue: ").fontWeight(.bold)
            Text("\(item.innerembedded?.venues[0].name ?? "") \(item.innerembedded?.venues[0].city.name ?? "")")
            Spacer()
          }
          HStack{
            Text("Date: ").fontWeight(.bold)
            Text(item.dates.start.localDate)
            Spacer()
          }
          if((item.priceRanges?[0].min) != nil && (item.priceRanges?[0].min) != 0){
            HStack{
              Text("Price range:").fontWeight(.bold)
              Text("$"+String(item.priceRanges?[0].min ?? 0))
              Text("-")
              Text("$"+String(item.priceRanges?[0].max ?? 0))
              Spacer()
            }
          }
            
        }.foregroundColor(Color.black)
          .padding()
        
        Spacer()
      }.background(Color.white.opacity(0.5))
        .cornerRadius(30, corners: .allCorners)

    }

  }
}
