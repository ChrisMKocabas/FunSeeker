//
//  FavouriteEventsView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-19.
//

import SwiftUI

struct FavouriteEventsView: View {

  @ObservedObject var eventViewModel: EventViewModel
  @ObservedObject var favouritesViewModel : FavouritesViewModel
  @ObservedObject var savedEventsViewModel : SavedEventsViewModel

  func getPercentage(geo: GeometryProxy) -> Double {
    let maxDistance = UIScreen.main.bounds.width / 2
    let currentX = geo.frame(in: .global).midX
    return Double(1 - (currentX / maxDistance))
  }

  let backgroundGradient = LinearGradient(
      colors: [Color.pink, Color.yellow],
      startPoint: .top, endPoint: .bottom)
    
    var body: some View {

      VStack{
        ZStack {
          backgroundGradient.ignoresSafeArea()

          ScrollView(.horizontal, showsIndicators: false, content: {
            HStack {
              ForEach(favouritesViewModel.favouriteEvents) { event in
                NavigationLink(value: event) {
                  GeometryReader { geometry in
                      VStack(alignment: .center){

                        HStack{
                          Spacer()
                          Button(action: {
                            Task{
                              await favouritesViewModel.removeFromFavourites(event: event)
                            }
                          }, label: {
                            Image(systemName: "xmark")
                              .foregroundColor(.red)
                              .font(.largeTitle)
                              .padding(20)

                          })
                        }
                        VStack(alignment: .leading){
                        Text((event.innerembedded?.attractions?[0].name)!)
                        }.foregroundColor(Color.white)
                          .font(.system(size: 36, weight: .heavy, design: .rounded))
                          .padding()
                        Spacer()
                        AsyncImage(url:URL(string: event.images[0].url.replacingOccurrences(of: "http://", with: "https://"))) { phase in
                          switch phase {
                          case .empty:
                            ProgressView()
                              .aspectRatio(contentMode: .fit)
                              .frame(maxWidth: 300, maxHeight: 300)
                              .clipShape(Circle()) // Add this line to clip to a circle
                          case .success(let image):
                            image
                              .resizable()
                              .aspectRatio(contentMode: .fill)
                              .frame(minWidth: 120, idealWidth: 300, maxWidth: 300, minHeight: 120, idealHeight: 300, maxHeight: 300, alignment: .center)
                              .clipShape(Circle())


                          case .failure(_):
                            Image("banner")
                              .resizable()
                              .aspectRatio(contentMode: .fill)
                              .frame(maxWidth: 300,maxHeight: 300)
                              .clipShape(Circle())
                          @unknown default:
                            EmptyView()
                          }
                        }.overlay(
                          Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth:10))
                        Spacer()
                    }.frame(width: 350, height: 550)
                      .background(Color.white.opacity(0.3))
                      .cornerRadius(30)
                      .overlay(
                          RoundedRectangle(cornerRadius: 30)
                              .stroke(.white, lineWidth:1)
                      )
                      .rotation3DEffect(
                        Angle(degrees: getPercentage(geo: geometry) * 40),
                        axis: (x: 0.0, y: 1.0, z: 0.0))
                  }
                  .frame(width: 350, height: 550)
                  .padding()

                }
              }
            }
          })
        }.navigationDestination(for: Event.self, destination: { item in
          FavouritesDetailedView(eventViewModel:eventViewModel,favouritesViewModel:favouritesViewModel, favouriteEvent:[item])
              .navigationBarTitleDisplayMode (.inline)
              .toolbarBackground(Color(red: 1, green: 0.3157, blue: 0.3333), for: .navigationBar)

          }
        )
        .navigationDestination(for: [Event].self, destination: { item in
          EventView(eventViewModel:eventViewModel,savedEventsViewModel:savedEventsViewModel, favouritesViewModel:favouritesViewModel, item:item)
            .navigationBarTitleDisplayMode (.inline)
            .toolbarBackground(Color(red: 1, green: 0.3157, blue: 0.3333), for: .navigationBar)
        })


      }.onAppear(perform:{
            Task{
              await favouritesViewModel.fetchUserFavourites()
            }
        })
        

    
  }
}

struct FavouriteEventsView_Previews: PreviewProvider {
    static var previews: some View {
      FavouriteEventsView(eventViewModel: EventViewModel(), favouritesViewModel: FavouritesViewModel(), savedEventsViewModel: SavedEventsViewModel())
    }
}

