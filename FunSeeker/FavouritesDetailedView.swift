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
  @Binding var parentNavigation: Bool

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
                ExtractedView(item:result)
              }
            }
          }
        }
      }.onAppear(perform:{
        self.parentNavigation = true
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
      FavouritesDetailedView(eventViewModel: EventViewModel(), firestoreManager: FirestoreManager(), favouriteEvent:PreviewEvents.load(name: "events"), parentNavigation: .constant(true))
    }
}


