//
//  FavouriteEventsView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-19.
//

import SwiftUI

struct FavouriteEventsView: View {

  @ObservedObject var eventViewModel: EventViewModel
  @ObservedObject var firestoreManager : FirestoreManager
  @State var parentNavigation = false

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
              ForEach(firestoreManager.favouriteEvents) { event in
                NavigationLink(value: event) {
                  GeometryReader { geometry in
                    VStack(alignment:.center){
                      //                    RoundedRectangle(cornerRadius: 20)
                      //                      .rotation3DEffect(
                      //                        Angle(degrees: getPercentage(geo: geometry) * 40),
                      //                        axis: (x: 0.0, y: 1.0, z: 0.0))
                      VStack(alignment: .center, spacing: 10){
                        Spacer()
                        VStack(alignment: .leading, spacing: 10){
                          Text((event.innerembedded?.attractions?[0].name)!)
                        }.foregroundColor(Color.black)
                        Spacer()
                        AsyncImage(url:URL(string: event.images[0].url.replacingOccurrences(of: "http://", with: "https://"))) { phase in
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
                              .frame(minWidth: 120, idealWidth: 250, maxWidth: 250, minHeight: 120, idealHeight: 250, maxHeight: 250, alignment: .center)
                              .clipShape(Circle())


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
                        Spacer()
                      }
                    }.frame(width: 350, height: 450)
                      .background(Color.white.opacity(0.7))
                      .cornerRadius(30)
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
          if (parentNavigation) {
            FavouritesDetailedView(eventViewModel:eventViewModel, firestoreManager:firestoreManager, favouriteEvent:[item], parentNavigation:$parentNavigation)
              .navigationBarTitleDisplayMode (.inline)
              .toolbarBackground(Color(red: 1, green: 0.3157, blue: 0.3333), for: .navigationBar)
              .onTapGesture(perform: {
                Task{
                  print("tap tap")
                  self.parentNavigation = false
                }
              })
          } else {
            EventView(eventViewModel:eventViewModel, firestoreManager:firestoreManager, item:[item])
              .navigationBarTitleDisplayMode (.inline)
              .toolbarBackground(Color(red: 1, green: 0.3157, blue: 0.3333), for: .navigationBar)
              .onDisappear(perform: {
                Task{
                  print("untap untap")
                  self.parentNavigation = true
                }
              })
          }
        })
      }.onAppear(perform:{
        self.parentNavigation = true

            Task{
//              await eventViewModel.getData()
              await firestoreManager.fetchUserFavourites()
            }
        })
        

    
  }
}

struct FavouriteEventsView_Previews: PreviewProvider {
    static var previews: some View {
      FavouriteEventsView(eventViewModel: EventViewModel(), firestoreManager: FirestoreManager())
    }
}

