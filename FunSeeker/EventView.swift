//
//  EventView.swift
//  FunSeeker
//
//  Created by Muhammed Kocabas on 2023-04-20.
//

import SwiftUI



struct EventView: View {

  @Environment(\.openURL) var openURL
  @ObservedObject var eventViewModel: EventViewModel
  @ObservedObject var firestoreManager: FirestoreManager
  let item:[Event]

  private func addToFavourites() async{
    await firestoreManager.saveToFirebase(event: item[0])
  }

  private func saveToFavourites(){

  }

  

    var body: some View {
      let backgroundGradient = LinearGradient(
          colors: [Color.red, Color.blue],
          startPoint: .top, endPoint: .bottom)

      ZStack {
        backgroundGradient.ignoresSafeArea()
        VStack{

          Spacer()
          AsyncImage(url:URL(string: item[0].images[0].url.replacingOccurrences(of: "http://", with: "https://"))) { phase in
            switch phase {
            case .empty:
              ProgressView()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 200)

            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity,maxHeight: 220)
                .blur(radius: 0.1)
                .clipped()
                .border(.black)

            case .failure(_):
              Image("banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity,maxHeight: 200)
            @unknown default:
              EmptyView()
            }

          }
          Spacer()
          VStack(alignment: .leading, spacing: 10){
            Text("\(item[0].name) \(item[0].type.capitalized)").font(Font.headline.weight(.bold))
            Text("Date: \(item[0].dates.start.localDate) - \(item[0].dates.start.localTime ?? "TBA")")
            VStack(alignment: .leading, spacing: 10){
              Text("Venue: \(item[0].innerembedded?.venues[0].name ?? "TBA")")
              Text("\(item[0].innerembedded?.venues[0].address.line1 ?? "TBA")")
              Text("\(item[0].innerembedded?.venues[0].city.name ?? "TBA") - \(item[0].innerembedded?.venues[0].country.name ?? "TBA")")
              Text("Tap to view on map").multilineTextAlignment(.center)

            }
            .onTapGesture {
              if let longtitude = item[0].innerembedded?.venues[0].location?.longitude,
                 let latitude = item[0].innerembedded?.venues[0].location?.latitude {
                let mapsURL = URL(string: "maps://q?\(latitude),\(longtitude)")!
                openURL(URL(string:"\(mapsURL)") ?? URL(string: "")!)
              }
            }
            Text("\(item[0].innerembedded?.venues[0].ada?.adaPhones ?? "")").foregroundColor(Color.indigo.opacity(0.6))
          }.padding(.horizontal,60)
            .padding(.vertical,20)
          .background(Color.white.opacity(0.6) .blur(radius: 20))


          Spacer()
          Button(action: {
            Task{
              await addToFavourites()
            }
          },label:{
            HStack {
              Spacer()
              Text("Add to Favourites")
              Spacer()
            }
          }).frame(maxWidth: .infinity,maxHeight: 60)
            .foregroundColor(Color.white)
            .background(Color.pink)
            .fontWeight(.semibold)
            .cornerRadius(20)
            .padding(.horizontal,20)

          Button( action: saveToFavourites) {
            HStack {
              Spacer()
              Text("Save This Event")
              Spacer()
            }
          }.frame(maxWidth: .infinity,maxHeight: 60)
            .foregroundColor(Color.white)
            .background(Color.green)
            .fontWeight(.semibold)
            .cornerRadius(20)
            .padding(.horizontal,20)

          Button("Buy Tickets (External)") {
            if let urlString = item[0].innerembedded?.attractions?[0].url {
              print("\(String(describing: urlString))")
              openURL(URL(string: "\(String(describing: urlString))") ?? URL(string: "https://www.ticketmaster.com/")!)
            }}.frame(maxWidth: .infinity,maxHeight: 60)
            .foregroundColor(Color.white)
            .background(Color.purple)
            .fontWeight(.semibold)
            .cornerRadius(20)
            .padding(.horizontal,20)
            .padding(.bottom,10)

        }
      }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
      EventView(eventViewModel: EventViewModel(), firestoreManager: FirestoreManager(), item:PreviewEvents.load(name: "events") )
    }
}
