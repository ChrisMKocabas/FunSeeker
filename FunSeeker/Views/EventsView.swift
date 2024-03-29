//
//  EventsView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-19.
//

import SwiftUI

struct EventsView: View {

  // View model objects
  @ObservedObject var eventViewModel: EventViewModel
  @ObservedObject var savedEventsViewModel: SavedEventsViewModel
  @ObservedObject var favouritesViewModel: FavouritesViewModel

  // Search text and filtered events
  @State private var searchText = ""
  @State private var filteredEvents = [Event]()

  // Toolbar visibility state
  @State private var toolbarVisibility : Visibility = .hidden

  // Network manager and local file manager
  @ObservedObject var networkManager:NetworkManager
  @ObservedObject var localFileManager: LocalFileManager

  // Editing and scroll position state
  @State private var isEditing = false
  @State var showToTopBtn = false
  @Namespace var topID
  @Namespace var bottomID
  @State private var scrollPosition: CGPoint = .zero

  // Filter state
  @State private var filtersEnabled = false

  // Background gradient
  let backgroundGradient = LinearGradient(
      colors: [Color.pink, Color.yellow],
      startPoint: .top, endPoint: .bottom)

  // Grid columns
  let columns:[GridItem] = [
    GridItem(.flexible(), spacing: 2,alignment: nil),
  ]

  // Minimum and maximum values for slider
  var minValue: Double = 10
  var maxValue: Double = 1000

  // Selected segment index for sorting
  @State private var selectedSegmentIndex = 3

   // Sortby string based on selected segment index
   var sortby: String{
       switch selectedSegmentIndex {
       case 0:
         return "&sort=date"
       case 1:
         return "&sort=distance"
       case 2:
           return "&sort=onSaleStartDate"
       case 3:
         return ""
       default:
           return ""
       }
   }

  var body: some View {
    VStack{
      ZStack {
        // Background gradient
        backgroundGradient.ignoresSafeArea()

        if (networkManager.isActive == true) {
          ScrollViewReader { proxy in
            ZStack(alignment: .bottom){
              ScrollView(showsIndicators: false){
                VStack{
                  if (filtersEnabled){
                    // Hide filters button
                    HStack(alignment:.center){
                      Spacer()
                      Text("Hide filters").foregroundColor(.black).fontWeight(.medium)
                      Image(systemName: "chevron.up")
                      Spacer()
                    }
                    .frame(maxWidth:.infinity, maxHeight:.infinity,alignment:.center)
                    .padding(.top)
                    .onTapGesture {
                      Task{
                        filtersEnabled = false
                      }
                    }
                    // Radius text
                    Text("\(eventViewModel.radius,specifier:"Maximum distance: %.f km")").font(.system(size: 18, weight: .bold, design: .rounded))
                      .padding(.top)
                    // Slider for radius
                    Slider(
                      value: $eventViewModel.radius,
                      in: minValue...maxValue,
                      step: 1
                    ) {
                      Text("Radius")
                    } minimumValueLabel: {
                      Text("\(minValue,specifier: "%.f km")")
                    } maximumValueLabel: {
                      Text("\(maxValue,specifier: "%.f km")")
                    }.padding()
                    .onChange(of: eventViewModel.radius, perform: { newValue in
                      Task{
                        if networkManager.isActive {
                          await eventViewModel.getData()
                          localFileManager.loadOfflineEvents(eventType: .mainfeed)
                        }
                      }
                    })
                    // Sortby text
                    Text("Sort events by \(sortby.replacingOccurrences(of: "&sort=", with: "").replacingOccurrences(of: "onSaleStartDate", with: "start of ticket sales "))").font(.system(size: 18, weight: .bold, design: .rounded))

                    // Picker for sorting
                    Picker("Sortby", selection: $selectedSegmentIndex) {
                      Text("Date").tag(0)
                      Text("Distance").tag(1)
                      Text("Goes Live").tag(2)
                      Text("None").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: sortby, perform: { newValue in
                      Task{
                        eventViewModel.sortby = newValue
                        eventViewModel.ascdesc = (newValue == "" ?  "" : ",asc")
                        if networkManager.isActive {
                          await eventViewModel.getData()
                          localFileManager.loadOfflineEvents(eventType: .mainfeed)
                        }
                      }
                    })
                  } else {
                    // Display filters button
                    HStack(alignment:.center){
                      Spacer()
                      Text("Display filters").foregroundColor(.black).fontWeight(.medium)
                      Image(systemName: "chevron.down")
                      Spacer()
                    }
                    .frame(maxWidth:.infinity, maxHeight:.infinity,alignment:.center)
                    .padding()
                    .onTapGesture {
                      Task{
                        filtersEnabled = true
                      }
                    }
                  }
                }
                .background(Color.pink.opacity(0.2))
                .background(Color.white.opacity(0.7))
                .cornerRadius(30, corners: .allCorners)
                .padding(.horizontal,8)
                .id(topID)

                // Event items grid
                LazyVGrid(columns:columns) {
                  GeometryReader{geo in}
                  ForEach(eventViewModel.events, id:\.self.id) {item in
                    SingleEventCellView(item:item)
                      .frame(maxWidth: .infinity, minHeight:350, maxHeight: 700)
                      .onAppear(perform:{
                        if eventViewModel.shouldLoadMoreData(id: item.id){
                          Task{
                            await eventViewModel.fetchMoreEvents()
                          }
                        }
                      })
                  }
                  .overlay(
                    RoundedRectangle(cornerRadius: 30)
                      .stroke(Color.white, lineWidth:1)
                  )
                  .padding(10)
                }
                // Hidden geometry reader background to track scroll position
                .background(GeometryReader { geometry in
                  Color.clear
                      .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                })
                // Read geometry reader value using preference key
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                  // Keep track of position
                  self.scrollPosition = value
                  // Toggle TO THE TOP button based on coordinates
                  showToTopBtn = value.y <= -300 ? true : false
                }
              }
              .refreshable {
                Task{
                  if networkManager.isActive {
                    await eventViewModel.getData()
                    localFileManager.loadOfflineEvents(eventType: .mainfeed)
                  }
                }
              }
              .onAppear(){
                Task{
                  if eventViewModel.events.isEmpty && networkManager.isActive {
                    await eventViewModel.getData()
                    localFileManager.loadOfflineEvents(eventType: .mainfeed)
                  }
                }
              }
              .onChange(of: eventViewModel.events) { newValue in
                Task {
                  localFileManager.saveEventFeed(events: newValue)
                  localFileManager.loadOfflineEvents(eventType: .mainfeed)
                }
              }
              if (showToTopBtn == true){
                // Back to the top button
                Button("Back to the top") {
                  withAnimation {
                    proxy.scrollTo(topID)
                  }
                }.buttonStyle(BacktoTopButton())
                  .id(bottomID)
                  .padding()
              }
            }
          }
        } else {
          ScrollView(showsIndicators: false){
            // Offline events grid
            LazyVGrid(columns:columns) {
              Text("No internet connection.")
              ForEach(localFileManager.offlineEvents, id:\.self.id) {item in
                SingleEventCellView(item:item)
                  .frame(maxWidth: .infinity, minHeight:350, maxHeight: 700)
              }
              .overlay(
                RoundedRectangle(cornerRadius: 30)
                  .stroke(Color.white, lineWidth:1)
              )
              .padding(10)
            }
          }
        }
      }
      .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always), prompt: "Looking for an event?") {
        ZStack{
          ScrollView {
            // Search suggestions grid
            LazyVGrid(columns:columns) {
              ForEach(eventViewModel.suggestions, id: \.self.id){ result in
                SingleEventCellView(item:result)
                  .searchCompletion(result)
              }
              .background(Color.black.opacity(0.2))
              .cornerRadius(30, corners: .allCorners)
              .padding()
            }
          }
        }
      }
      .onChange(of: searchText) { value in
        Task {
          if value.count >= 3 {
            eventViewModel.suggestionTerm = value
            await eventViewModel.fetchSuggestions()
          }
          else {
            eventViewModel.suggestions = []
          }
        }
      }
      .onSubmit(of: .search){
        Task{
          eventViewModel.suggestionTerm = ""
          eventViewModel.suggestions = []
        }
      }
   }
   .navigationDestination(for: Event.self, destination: { item in
     EventView(eventViewModel:eventViewModel, savedEventsViewModel:savedEventsViewModel,favouritesViewModel:favouritesViewModel, item:[item])
       .navigationBarTitleDisplayMode (.inline)
   })
  }
}

struct EventsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack{
      EventsView(eventViewModel: EventViewModel(),savedEventsViewModel: SavedEventsViewModel(), favouritesViewModel: FavouritesViewModel()
                 ,networkManager: NetworkManager(), localFileManager: LocalFileManager()).environmentObject(LocationManager())
    }
  }
}




struct SingleEventCellView: View {

  let item: Event

  var body: some View {
    NavigationLink(value: item) {
      VStack {
        ZStack(alignment: .bottomTrailing) {
          // AsyncImage to display the event image
          AsyncImage(url: URL(string: item.images.filter({ xImage in
            xImage.width >= 1000
          }).first!.url.replacingOccurrences(of: "http://", with: "https://"))) { phase in
            switch phase {
            case .empty:
              // Show a progress view while the image is loading
              ProgressView()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 250)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            case .success(let image):
              // Display the loaded image
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 200)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            case .failure(_):
              // Show a placeholder image if loading fails
              Image("banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 250)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            @unknown default:
              EmptyView()
            }
          }
          HStack {
            // Display the countdown timer for the event start time
            Text("Starts in: ")
              .foregroundColor(Color.black)
              .font(.system(size: 16, weight: .light, design: .rounded))
            CountDownTimerView(referenceDate: ISO8601DateFormatter().date(from: item.dates.start.dateTime ?? "2023-06-12T22:30:00Z")!)
              .foregroundColor(.black)
          }
          .padding(.horizontal, 10)
          .padding(.vertical, 5)
          .background(Color.white.opacity(1))
          .cornerRadius(10, corners: .allCorners)
        }
        .overlay(
          RoundedRectangle(cornerRadius: 30)
            .stroke(Color.white, lineWidth: 2)
        )
        Spacer()
        VStack(alignment: .leading, spacing: 10) {
          // Display the event name
          Text(item.name)
            .multilineTextAlignment(.leading)
            .fontWeight(.bold)
          HStack(alignment: .top) {
            // Display the venue information
            Text("Venue: ")
              .fontWeight(.bold)
            Text("\(item.innerembedded?.venues[0].name ?? "") \(item.innerembedded?.venues[0].city.name ?? "")")
            Spacer()
          }
          HStack {
            // Display the date and time of the event
            Text("Date: ")
              .fontWeight(.bold)
            Text("\(item.dates.start.localDate) \(String(item.dates.start.localTime?.prefix(upTo: String.Index(utf16Offset: 5, in: item.dates.start.localTime!)) ?? ""))")
            Spacer()
          }
          if let priceRange = item.priceRanges?[0] {
            if priceRange.min != nil && priceRange.min != 0 {
              // Display the price range of the event
              HStack {
                Text("Price range:")
                  .fontWeight(.bold)
                Text("$\(priceRange.min ?? 0)-$\(priceRange.max ?? 0)")
                Spacer()
              }
            }
          }
          if let distance = item.innerembedded?.venues[0].distances {
            // Display the distance to the venue
            HStack {
              Text("Distance: ")
                .fontWeight(.bold)
              Text("\(Int(distance)) km")
              Spacer()
            }
          }
        }
        .foregroundColor(Color.black)
        .padding()
        Spacer()
      }
      .background(Color.white.opacity(0.5))
      .cornerRadius(30, corners: .allCorners)

    }

  }
}

struct BacktoTopButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue.opacity(0.8))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
      // No reduction needed for this preference key
    }
}
