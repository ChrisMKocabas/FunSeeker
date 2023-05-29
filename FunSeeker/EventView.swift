//
//  EventView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-20.
//

import SwiftUI




struct EventView: View {

  @Environment(\.openURL) var openURL
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var sharedInformation:SharedInfo
  @ObservedObject var eventViewModel: EventViewModel
  @ObservedObject var firestoreManager: FirestoreManager

  @State var isExpanded = false
  @State var subviewHeight : CGFloat = 0
  
  let item:[Event]

  private func saveEvent() async{
    await firestoreManager.saveToFirebase(event: item[0])
  }

  private func saveToFavourites() async{
    await firestoreManager.saveFavourite(event: item[0])
  }

  private func removeSavedEvent() async {
    await firestoreManager.removeSavedEvent(event: item[0])
  }

  let backgroundGradient = LinearGradient(
      colors: [Color.pink, Color.yellow],
      startPoint: .top, endPoint: .bottom)

  let columns:[GridItem] = [
    GridItem(.flexible(), spacing: 2,alignment: nil),
//    GridItem(.flexible(), spacing: 2,alignment: nil)

  ]

  var body: some View {

    ScrollView{
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
            Text("\(item[0].name) \(item[0].type?.capitalized ?? "")").font(Font.headline.weight(.bold))
            HStack{
              Text("Date: ").fontWeight(.bold)
              Text(item[0].dates.start.localDate)
              Spacer()
              Text("Time: ").fontWeight(.bold)
              Text(item[0].dates.start.localTime ?? "TBA")
            }
            VStack(alignment: .leading, spacing: 10){
              HStack{
                Text("Venue: ").fontWeight(.bold)
                Text(item[0].innerembedded?.venues[0].name ?? "TBA")
              }
              HStack(alignment: .top){
                Text("Address: ").fontWeight(.bold)
                VStack(alignment: .leading){
                  Text("\(item[0].innerembedded?.venues[0].address.line1 ?? "TBA")")
                  Text("\(item[0].innerembedded?.venues[0].city.name ?? "TBA") - \(item[0].innerembedded?.venues[0].country.name ?? "TBA")")
                  Text("Tap to view on map").multilineTextAlignment(.center).foregroundColor(.indigo)
                    .onTapGesture {
                      if let longtitude = item[0].innerembedded?.venues[0].location?.longitude,
                         let latitude = item[0].innerembedded?.venues[0].location?.latitude {
                        let mapsURL = URL(string: "maps://q?\(latitude),\(longtitude)")!
                        openURL(URL(string:"\(mapsURL)") ?? URL(string: "")!)
                      }
                    }
                }
                
              }
            }

            
            VStack {
              Text("Additional info:").fontWeight(.bold)
              if ((item.first?.info) != nil) {Text("Tap to expand").foregroundColor(Color.gray)}
              Text(item.first?.info ?? "").lineLimit(15,reservesSpace: true)
              HStack{
                Text((item[0].innerembedded?.venues[0].ada?.adaPhones ?? "").replacingOccurrences(of: "Ticketmaster:", with: "Contact:")).lineLimit(3,reservesSpace: true)
                Spacer()
              }
              
            }
            .background(GeometryReader {
              Color.clear.preference(key: ViewHeightKey.self,
                                     value: $0.frame(in: .local).size.height)
            })
            .onPreferenceChange(ViewHeightKey.self) { subviewHeight = $0 }
            .frame(height: isExpanded ? subviewHeight : 80, alignment: .top)
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
            

            
          }.padding()
          
          
          
          
          Spacer()
          Button(action: {
            Task{
              if !(sharedInformation.currentTab == 2){
                await saveEvent()
              }else {
                await removeSavedEvent()
                presentationMode.wrappedValue.dismiss()
              }
            }
          },label:{
            HStack {
              Spacer()
              (sharedInformation.currentTab == 2) ? Text("Remove Saved Event") : Text("Save This Event")
              
              Spacer()
            }
          }).frame(width: 300,height: 40)
            .foregroundColor(Color.white)
            .background(Color.pink)
            .fontWeight(.semibold)
            .cornerRadius(20)
            .padding(.horizontal,20)
            .padding(.bottom,5)
          
          if !(sharedInformation.currentTab == 1){
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
            }).frame(width: 300,height: 40)
              .foregroundColor(Color.white)
              .background(Color.green)
              .fontWeight(.semibold)
              .cornerRadius(20)
              .padding(.horizontal,20)
              .padding(.bottom,5)
          } else {
          }
          
          Button("Buy Tickets (External)") {
            if let urlString = item[0].innerembedded?.attractions?[0].url {
              print("\(String(describing: urlString))")
              openURL(URL(string: "\(String(describing: urlString))") ?? URL(string: "https://www.ticketmaster.com/")!)
            }}.frame(width: 300,height: 40)
            .foregroundColor(Color.white)
            .background(Color.purple)
            .fontWeight(.semibold)
            .cornerRadius(20)
            .padding(.horizontal,20)
            .padding(.bottom,0)
          
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)

        .padding(.bottom,10)
        .background(Color.white.opacity(1).blur(radius: 1))
        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
        .offset(y: -25)
        .zIndex(1)
        

    }.clipped()
      .background(backgroundGradient.ignoresSafeArea())
      .toolbarBackground(Color(red: 1, green: 0.3157, blue: 0.3333), for: .navigationBar)

  }

} 

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
      EventView(eventViewModel: EventViewModel(), firestoreManager: FirestoreManager(), item:PreviewEvents.load(name: "events") ).environmentObject(SharedInfo())
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

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
