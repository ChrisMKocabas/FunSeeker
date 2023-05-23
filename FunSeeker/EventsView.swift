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
  @State private var filteredEvents = [Event]()
  @State private var toolbarVisibility : Visibility = .hidden
  

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
        ScrollView(showsIndicators: false){
//          ZStack{
//            Image("banner")
//              .resizable()
//              .scaledToFill()
//              .frame(maxWidth: .infinity, maxHeight: 240)
//              .clipped()
//              .blur(radius: 15)
//              .padding(.bottom,20)
//
//            Image("banner")
//              .resizable()
//              .scaledToFill()
//              .frame(maxWidth: .infinity, maxHeight: 200)
//              .clipped()
//          }
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
        }
        .onAppear(){
          Task{
            await eventViewModel.getData()
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
//          .navigationDestination(for: Event.self, destination: { item in
//            EventView(eventViewModel:eventViewModel, firestoreManager:firestoreManager, item:[item])
//              .navigationBarTitleDisplayMode (.inline)
//          })
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
     EventView(eventViewModel:eventViewModel, firestoreManager:firestoreManager, item:[item])
       .navigationBarTitleDisplayMode (.inline)
       .transaction {
         $0.animation = .default.speed(1.5)
       }
   })
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
        VStack(alignment: .center, spacing: 10){
          Text(item.name)
          Text(item.innerembedded?.venues[0].name ?? "")
          Text(item.dates.start.localDate)
        }.foregroundColor(Color.black)
        Spacer()
      }.background(Color.white.opacity(0.5))
        .cornerRadius(30, corners: .allCorners)

    }

  }
}
