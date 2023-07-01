//
//  EventView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-20.
//

import SwiftUI

struct EventView: View {

  // Environment variables
  @Environment(\.openURL) var openURL
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var sharedInformation: SharedInfo

  // Observed object variables
  @ObservedObject var eventViewModel: EventViewModel
  @ObservedObject var savedEventsViewModel: SavedEventsViewModel
  @ObservedObject var favouritesViewModel: FavouritesViewModel

  // State variables
  @State var isExpanded = false
  @State var subviewHeight: CGFloat = 0

  let item: [Event]

  // Save event to Firebase
  private func saveEvent() async {
    await savedEventsViewModel.saveToFirebase(event: item[0])
  }

  // Save event to favourites
  private func saveToFavourites() async {
    await favouritesViewModel.saveFavourite(event: item[0])
  }

  // Remove saved event
  private func removeSavedEvent() async {
    await savedEventsViewModel.removeSavedEvent(event: item[0])
  }

  // Background gradient for the view
  let backgroundGradient = LinearGradient(
    colors: [Color.pink, Color.yellow],
    startPoint: .top, endPoint: .bottom
  )

  // Grid layout for the view
  let columns: [GridItem] = [
    GridItem(.flexible(), spacing: 2, alignment: nil),
//    GridItem(.flexible(), spacing: 2, alignment: nil)
  ]

  var body: some View {
    ScrollView {

      // Asynchronously load and display the event image
      AsyncImage(url: URL(string: item[0].images.filter({ xImage in
        xImage.width >= 1000
      }).first?.url.replacingOccurrences(of: "http://", with: "https://") ?? "...")
      ) { phase in
        switch phase {
        case .empty:
          ProgressView()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: 220)
            .clipShape(RoundedRectangle(cornerRadius: 20))

        case .success(let image):
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: 220)
            .clipShape(RoundedRectangle(cornerRadius: 20))

        case .failure(_):
          Image("banner")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: 220)
            .clipShape(RoundedRectangle(cornerRadius: 20))

        @unknown default:
          EmptyView()
        }
      }

      Spacer()

      VStack {
        VStack(alignment: .leading, spacing: 10) {
          Text("\(item[0].name) \(item[0].type?.capitalized ?? "")")
            .font(Font.headline.weight(.bold))
          HStack {
            Text("Date: ")
              .fontWeight(.bold)
            Text(item[0].dates.start.localDate)
            Spacer()
            Text("Time: ")
              .fontWeight(.bold)
            Text(item[0].dates.start.localTime ?? "TBA")
          }

          VStack(alignment: .leading, spacing: 10) {
            HStack {
              Text("Venue: ")
                .fontWeight(.bold)
              Text(item[0].innerembedded?.venues[0].name ?? "TBA")
            }

            HStack(alignment: .top) {
              Text("Address: ")
                .fontWeight(.bold)
              VStack(alignment: .leading) {
                Text("\(item[0].innerembedded?.venues[0].address.line1 ?? "TBA")")
                Text("\(item[0].innerembedded?.venues[0].city.name ?? "TBA") - \(item[0].innerembedded?.venues[0].country.name ?? "TBA")")
                Text("Tap to view on map")
                  .multilineTextAlignment(.center)
                  .foregroundColor(.indigo)
                  .onTapGesture {
                    if let longitude = item[0].innerembedded?.venues[0].location?.longitude,
                       let latitude = item[0].innerembedded?.venues[0].location?.latitude {
                      let mapsURL = URL(string: "maps://q?\(latitude),\(longitude)")!
                      openURL(URL(string: "\(mapsURL)") ?? URL(string: "")!)
                    }
                  }
              }
            }
          }

          VStack {
            Text("Additional info:")
              .fontWeight(.bold)
            if ((item.first?.info) != nil) {
              Text("Tap to expand")
                .foregroundColor(Color.gray)
            }

            Text("Price Intel: ")
              .fontWeight(.bold)
            BarChartView(
              min: item[0].priceRanges?[0].min ?? 0,
              max: item[0].priceRanges?[0].max ?? 0
            )

            Text("Special considerations:")
              .fontWeight(.bold)
            Text(item.first?.info ?? "")
              .lineLimit((item.first?.info?.count ?? 25) / 25, reservesSpace: true)

            HStack {
              Text((item[0].innerembedded?.venues[0].ada?.adaPhones ?? "").replacingOccurrences(of: "Ticketmaster:", with: "Contact:"))
                .lineLimit(3, reservesSpace: true)
              Spacer()
            }
          }
          .background(GeometryReader {
            Color.clear.preference(
              key: ViewHeightKey.self,
              value: $0.frame(in: .local).size.height
            )
          })
          .onPreferenceChange(ViewHeightKey.self) { subviewHeight = $0 }
          .frame(height: isExpanded ? subviewHeight : 60, alignment: .top)
          .padding()
          .clipped()
          .frame(maxWidth: .infinity)
          .transition(.move(edge: .bottom))
          .background(Color(red: 0.97, green: 0.97, blue: 1).cornerRadius(10.0))
          .onTapGesture {
            withAnimation(.easeIn(duration: 0.5)) {
              isExpanded.toggle()
            }
          }
        }
        .padding()

        Spacer()

        Button(action: {
          Task {
            if !(sharedInformation.currentTab == 2) {
              await saveEvent()
            } else {
              await removeSavedEvent()
              presentationMode.wrappedValue.dismiss()
            }
          }
        }) {
          HStack {
            Spacer()
            (sharedInformation.currentTab == 2) ? Text("Remove Saved Event") : Text("Save This Event")
            Spacer()
          }
        }
        .frame(width: 300, height: 40)
        .foregroundColor(Color.white)
        .background(Color.pink)
        .fontWeight(.semibold)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.bottom, 5)

        if !(sharedInformation.currentTab == 1) {
          Button(action: {
            Task {
              await saveToFavourites()
            }
          }) {
            HStack {
              Spacer()
              Text("Add to Favourites")
              Spacer()
            }
          }
          .frame(width: 300, height: 40)
          .foregroundColor(Color.white)
          .background(Color.green)
          .fontWeight(.semibold)
          .cornerRadius(20)
          .padding(.horizontal, 20)
          .padding(.bottom, 5)
        }

        Button("Buy Tickets (External)") {
          if let urlString = item[0].innerembedded?.attractions?[0].url {
            print("\(String(describing: urlString))")
            openURL(URL(string: "\(String(describing: urlString))") ?? URL(string: "https://www.ticketmaster.com/")!)
          } else {
            toast("Not available", size: .large)
          }
        }
        .frame(width: 300, height: 40)
        .foregroundColor(Color.white)
        .background(Color.purple)
        .fontWeight(.semibold)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.bottom, 0)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding(.bottom, 10)
      .background(Color.white.opacity(1).blur(radius: 1))
      .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
      .offset(y: -25)
      .zIndex(1)
    }
    .clipped()
    .background(backgroundGradient.ignoresSafeArea())
    .toolbarBackground(Color(red: 1, green: 0.3157, blue: 0.3333), for: .navigationBar)
  }
}

struct EventView_Previews: PreviewProvider {
  static var previews: some View {
    EventView(
      eventViewModel: EventViewModel(),
      savedEventsViewModel: SavedEventsViewModel(),
      favouritesViewModel: FavouritesViewModel(),
      item: PreviewEvents.load(name: "events")
    ).environmentObject(SharedInfo())
  }
}

struct ViewHeightKey: PreferenceKey {
  static var defaultValue: CGFloat { 0 }

  static func reduce(value: inout Value, nextValue: () -> Value) {
    value = value + nextValue()
  }
}
