//
//  EventsView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-19.
//

import SwiftUI


struct EventsView: View {

  @ObservedObject var eventViewModel: EventViewModel
  @State private var searchText = ""
  @State private var filtering = false
  @State private var filteredEvents = [Event]()

  var body: some View {


    let columns:[GridItem] = [
      GridItem(.flexible(), spacing: 5,alignment: nil),
      GridItem(.flexible(), spacing: 5,alignment: nil)

    ]

    ScrollView(showsIndicators: false){

      ZStack{

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
                  .frame(maxWidth: .infinity, maxHeight: 80)
                  .clipShape(Circle()) // Add this line to clip to a circle
              case .success(let image):
                image
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(maxWidth: 80,maxHeight: 80)
                  .clipShape(Circle()) // Add this line to clip to a circle
              case .failure(_):
                Image("banner")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(maxWidth: .infinity,maxHeight: 80)
                  .clipShape(Circle())
              @unknown default:
                EmptyView()
              }
            }

            Text(item.id)
            Text(item.name)
            }

          }.frame(height: 200)
            .onAppear(perform:{
              if eventViewModel.shouldLoadMoreData(id: item.id){
                Task{
                  await eventViewModel.fetchMoreEvents()
                }
              }
            })
        }
      }
      }.navigationDestination(for: Event.self, destination: { item in
        EventView(item:[item])
      })
      .onAppear(){
      Task{
        await eventViewModel.getData()

      }
    } .searchable(text: $searchText,prompt: "Looking for an event?") { ForEach(searchResults, id: \.self){ result in
          Text("Are you looking for \(result)?").searchCompletion(result)
        }
    }
  }

  var searchResults: [String] {
      if searchText.isEmpty {
        filtering = false
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
      EventsView(eventViewModel: EventViewModel())
    }
    
  }
}
