//
//  EventView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-20.
//

import SwiftUI



struct EventView: View {

  @Environment(\.openURL) var openURL
  @ObservedObject var eventViewModel: EventViewModel
  @ObservedObject var firestoreManager: FirestoreManager
  let item:[Event]

  private func saveEvent() async{
    await firestoreManager.saveToFirebase(event: item[0])
  }

  private func saveToFavourites() async{
    await firestoreManager.saveFavourite(event: item[0])
  }
 
//  let backgroundGradient = LinearGradient(
//    colors: [Color.red, Color.blue],
//    startPoint: .top, endPoint: .bottom)


  let backgroundGradient = LinearGradient(
      colors: [Color.pink, Color.yellow],
      startPoint: .top, endPoint: .bottom)
  
  var body: some View {

      ZStack {
        backgroundGradient.ignoresSafeArea()
        VStack{

          AsyncImage(url:URL(string: item[0].images[0].url.replacingOccurrences(of: "http://", with: "https://"))) { phase in
            switch phase {
            case .empty:
              ProgressView()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity,maxHeight: 220)

            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity,maxHeight: 220)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            case .failure(_):
              Image("banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity,maxHeight: 220)
            @unknown default:
              EmptyView()
            }

          }
          Spacer()
          VStack{
            VStack(alignment: .leading, spacing: 10){
              Text("\(item[0].name) \(item[0].type?.capitalized ?? "Event")").font(Font.headline.weight(.bold))
              Text("Date: \(item[0].dates.start.localDate) - Time: \(item[0].dates.start.localTime ?? "TBA")")
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
            }



            Spacer()
            Button(action: {
              Task{
                await saveEvent()
              }
            },label:{
              HStack {
                Spacer()
                Text("Save This Event")
                Spacer()
              }
            }).frame(maxWidth: 300,maxHeight: 40)
              .foregroundColor(Color.white)
              .background(Color.pink)
              .fontWeight(.semibold)
              .cornerRadius(20)
              .padding(.horizontal,20)
              .padding(.bottom,5)

            Button(action: {
              Task{
                await saveToFavourites()
              }
            }, label: {
              HStack {
                Spacer()
                Text("Add to Favourites")
                Spacer()
              }
            }).frame(maxWidth: 300,maxHeight: 40)
              .foregroundColor(Color.white)
              .background(Color.green)
              .fontWeight(.semibold)
              .cornerRadius(20)
              .padding(.horizontal,20)
              .padding(.bottom,5)

            Button("Buy Tickets (External)") {
              if let urlString = item[0].innerembedded?.attractions?[0].url {
                print("\(String(describing: urlString))")
                openURL(URL(string: "\(String(describing: urlString))") ?? URL(string: "https://www.ticketmaster.com/")!)
              }}.frame(maxWidth: 300,maxHeight: 40)
              .foregroundColor(Color.white)
              .background(Color.purple)
              .fontWeight(.semibold)
              .cornerRadius(20)
              .padding(.horizontal,20)
              .padding(.bottom,0)

          }
          .frame(maxWidth: .infinity,maxHeight: .infinity)
          .padding(.top,10)
          .padding(.bottom,10)
          .padding(.vertical,20)
          .background(Color.white.opacity(1).blur(radius: 1))
          .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
          .offset(y: -25)
          .zIndex(1)

        }
        .padding(.horizontal,0)
    }
  }
} 

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
      EventView(eventViewModel: EventViewModel(), firestoreManager: FirestoreManager(), item:PreviewEvents.load(name: "events") )
    }
}


//Custom corner radius implementation below

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Custom corner radius implementation ends
