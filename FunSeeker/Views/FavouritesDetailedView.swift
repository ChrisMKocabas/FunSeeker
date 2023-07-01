//
//  FavouritesDetailedView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-05-20.
//

// Importing necessary modules
import SwiftUI

// Struct for the detailed view of favorite events
struct FavouritesDetailedView: View {

  // Observed objects for event and favorites view models
  @ObservedObject var eventViewModel: EventViewModel
  @ObservedObject var favouritesViewModel: FavouritesViewModel

  // Array of favorite events
  @State var favouriteEvent: [Event]

  // Grid layout for the view
  let columns:[GridItem] = [
    GridItem(.flexible(), spacing: 2, alignment: nil)
  ]

  // Background gradient for the view
  let backgroundGradient = LinearGradient(
      colors: [Color.pink, Color.yellow],
      startPoint: .top, endPoint: .bottom)

  // Body of the view
  var body: some View {
    VStack{
      ZStack{
        // Applying background gradient
        backgroundGradient.ignoresSafeArea()

        // ScrollView for the favorite events
        ScrollView {
          LazyVGrid(columns:columns) {
            // Iterating over favorite events
            ForEach(eventViewModel.favourites, id: \.self.id){ result in
              // Displaying the detailed view for each event
              FavouriteDetailView(item:result)
            }
          }
        }

        // Displaying a message if there are no favorite events
        if (eventViewModel.favourites.isEmpty) {
          Text("Nothing to display.")
        }
      }
    }.onAppear(perform:{
      // Fetching favorites when the view appears
      Task{
        // Setting the favorite term
        eventViewModel.favouriteTerm = (favouriteEvent.first?.innerembedded?.attractions?.first!.name)!
        print(eventViewModel.favouriteTerm)
        await eventViewModel.fetchFavourites()
      }
    })
  }
}

// Preview struct for the FavouritesDetailedView
struct FavouritesDetailedView_Previews: PreviewProvider {

  // Binding for parent navigation
  @Binding var parentNavigation: Bool

  // Preview content
  static var previews: some View {
    FavouritesDetailedView(eventViewModel: EventViewModel(), favouritesViewModel:FavouritesViewModel(), favouriteEvent:PreviewEvents.load(name: "events"))
  }
}

// Struct for the detailed view of a single favorite event
struct FavouriteDetailView: View {

  // Favorite event item
  let item: Event

  // Body of the view
  var body: some View {
    NavigationLink(value: [item]) {
      VStack{
        // Displaying the event image
        AsyncImage(url:URL(string: item.images[0].url.replacingOccurrences(of: "http://", with: "https://"))) { phase in
          switch phase {
          case .empty:
            // Show progress view when image is empty
            ProgressView()
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: .infinity,maxHeight: 250)
              .clipShape(Ellipse())
          case .success(let image):
            // Show the loaded image
            image
              .resizable()
              .scaledToFill()
              .aspectRatio(contentMode: .fill)
              .frame(maxWidth: .infinity,maxHeight: 250)
              .clipped()
              .cornerRadius(30)
          case .failure(_):
            // Show a default image on failure
            Image("banner")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(maxWidth: .infinity,maxHeight: 250)
              .clipShape(Ellipse())
          @unknown default:
            EmptyView()
          }
        }

        // Displaying event details
        VStack(alignment: .center, spacing: 10){
          Text("\(item.name)").font(Font.headline.weight(.bold))
          HStack{
            Text("@").fontWeight(.bold)
            Text(item.innerembedded?.venues[0].name ?? "")
          }
          HStack{
            Text("Date: ").fontWeight(.bold)
            Text(item.dates.start.localDate)
            Text("Time: ").fontWeight(.bold)
            Text(item.dates.start.localTime ?? "TBA")
          }

          // Displaying event price if available
          if((item.priceRanges?[0].min) != nil && (item.priceRanges?[0].min) != 0){
            HStack{
              Spacer()
              Text("Starting from").fontWeight(.bold)
              Text("$ \(Int((item.priceRanges?[0].min)!)).00")
              Spacer()
            }
          }
        }.foregroundColor(Color.black)
      }
      // Styling the view
      .overlay(
        RoundedRectangle(cornerRadius: 30)
          .stroke(Color.white, lineWidth:1))
      .background(Color.white.opacity(0.5))
      .cornerRadius(30, corners: .allCorners)
      .padding(10)
    }
  }
}
