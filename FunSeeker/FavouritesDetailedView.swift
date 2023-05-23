//
//  FavouritesDetailedView.swift
//  FunSeeker
//
//  Created by Muhammed Kocabas on 2023-05-20.
//

import SwiftUI

struct FavouritesDetailedView: View {

  @ObservedObject var eventViewModel: EventViewModel
  @ObservedObject var firestoreManager : FirestoreManager
  @State var favouriteEvent: [Event]

  let columns:[GridItem] = [
    GridItem(.flexible(), spacing: 2,alignment: nil)
  ]

  let backgroundGradient = LinearGradient(
      colors: [Color.pink, Color.yellow],
      startPoint: .top, endPoint: .bottom)

    var body: some View {
      VStack{
        ZStack{
          backgroundGradient.ignoresSafeArea()
          ScrollView {
            LazyVGrid(columns:columns) {
              ForEach(eventViewModel.favourites, id: \.self.id){ result in
                FavouriteDetailView(item:result)
              }
            }
          }
          if (eventViewModel.favourites.isEmpty) {Text("Nothing to display.")}
        }
      }.onAppear(perform:{
        Task{
          eventViewModel.favouriteTerm = (favouriteEvent.first?.innerembedded?.attractions?.first!.name)!
          print(eventViewModel.favouriteTerm)
          await eventViewModel.fetchFavourites()
        }
      })

    }
}

struct FavouritesDetailedView_Previews: PreviewProvider {

  @Binding var parentNavigation:Bool 

    static var previews: some View {
      FavouritesDetailedView(eventViewModel: EventViewModel(), firestoreManager: FirestoreManager(), favouriteEvent:PreviewEvents.load(name: "events"))
    }
}


struct FavouriteDetailView: View {

  let item: Event
  var body: some View {
    NavigationLink(value: [item]) {
        VStack{
          AsyncImage(url:URL(string: item.images[0].url.replacingOccurrences(of: "http://", with: "https://"))) { phase in
            switch phase {
            case .empty:
              ProgressView()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity,maxHeight: 250)
                .clipShape(Ellipse()) // Add this line to clip to a circle
            case .success(let image):
              image
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity,maxHeight: 250)
                .clipped()
                .cornerRadius(30)

            case .failure(_):
              Image("banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity,maxHeight: 250)
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
          
        }.overlay(
          RoundedRectangle(cornerRadius: 30)
            .stroke(Color.white, lineWidth:1))
        .background(Color.white.opacity(0.5))
          .cornerRadius(30, corners: .allCorners)
          .padding(10)

    }

  }
}
