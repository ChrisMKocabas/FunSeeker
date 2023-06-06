//
//  EventViewModel.swift
//  FunSeeker
//
//  Created by Muhammed Kocabas on 2023-05-29.
//

import Foundation
import CoreLocation
import Combine

class EventViewModel:NSObject,ObservableObject {

  struct Constants {
    static let API_KEY = "tgy0mOAGfxD4jSYSX86F0W6OuS33wZ0H"
    static let baseURL = "https://app.ticketmaster.com/discovery/v2/"
    static let fallbackURL = "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=CA&page=0&size=20&apikey=tgy0mOAGfxD4jSYSX86F0W6OuS33wZ0H"
  }
  @Published var events = [Event]()
  @Published var suggestions = [Event]()
  @Published var favourites = [Event]()
  @Published var countrycode:String = "CA"
  @Published var maxPageLoaded:Int=0
  @Published var suggestionTerm: String = ""
  @Published var favouriteTerm: String = ""
  @Published var radius: Double = 200
  @Published var sortby: String = ""
  @Published var ascdesc: String = ""
  @Published var geolocationInitialized = false

  private var locationManager: LocationManager
  private var cancellables = Set<AnyCancellable>()

  private var geolocation:String {
    didSet{
      if (geolocationInitialized == false && geolocation != "") {
        DispatchQueue.main.async {
          Task{
            await self.getData()
            self.geolocationInitialized = true
            print("Hooyt")
          }
        }
      }
      UserDefaults.standard.set(geolocation,forKey: "geolocation")
    } willSet{}
  }

  // Observe changes to the LocationManager properties
   private func handleLocationManagerChanges() {
       // Handle changes to authorizationStatus, latitude, longitude properties
       // Access them directly from the LocationManager instance
//       let authorizationStatus = locationManager.authorizationStatus
       let latitude = locationManager.latitude
       let longitude = locationManager.longitude

     if (latitude != 0 && longitude != 0){
       DispatchQueue.main.async {
         self.geolocation = Geohash.encode(latitude: latitude, longitude: longitude, length: 9)

         print("Hello from eventview model: \(self.geolocation)")

       }


     }

   }

  override init() {

      self.geolocation = UserDefaults.standard.string(forKey: "geolocation") ?? ""
      locationManager = LocationManager.shared
      super.init()
      // Observe the LocationManager objectWillChange publisher
      locationManager.objectWillChange
          .sink { [weak self] _ in
              // Handle location manager changes here
              self?.handleLocationManagerChanges()
          }
          .store(in: &cancellables)

  }

    deinit {
        // Cancel all subscriptions when the object is deallocated
        cancellables.forEach { $0.cancel() }
    }

  func getData() async{
    do{
      let data = try await fetchEvents(pageNo:0)
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let welcome = try decoder.decode(Welcome.self, from: data)
      DispatchQueue.main.async{
        self.events = welcome.embedded.events
        print("I got the powaaah!")
      }
    } catch {
      print(String(describing:error))
    }
  }

  func fetchEvents(pageNo:Int) async throws  -> Data{
    let currentDate = NSDate.now.ISO8601Format()
    let url = URL(string: "\(Constants.baseURL)events.json?countryCode=\(countrycode)&geoPoint=\(geolocation)&radius=\(Int(radius))&unit=km&startDateTime=\(currentDate)\(sortby)\(ascdesc)&page=\(pageNo)&size=20&apikey=\(Constants.API_KEY)")!
        let (data, _) = try await URLSession.shared.data(from: url)
//    print("--> data: \(String(describing: String(data: data, encoding: .utf8)))")
    print(url)
        return data
  }


  func fetchMoreEvents() async {
    do{
      let data = try await fetchEvents(pageNo:maxPageLoaded+1)
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let welcome = try decoder.decode(Welcome.self, from: data)
      DispatchQueue.main.async{
        self.events.append(contentsOf:welcome.embedded.events)
        self.maxPageLoaded+=1
        print("Page loaded \(self.events.count)")
      }
    } catch {
      print(String(describing:error))
    }
  }

  func shouldLoadMoreData(id:String) -> Bool {
    if events.count > 19 {
      return id == events[events.count-4].id
    } else {
      return false
    }
  }


  func parseSample() -> Event?{
    if let fileUrl = Bundle.main.url(forResource: "eventsample", withExtension: "json") {
         do {
           let data = try Data(contentsOf: fileUrl)
              let decoder = JSONDecoder()
              decoder.keyDecodingStrategy = .convertFromSnakeCase
              let welcome = try decoder.decode(Welcome.self, from: data)
           let sampleEvents = welcome.embedded.events
           print(sampleEvents[0])
              return sampleEvents[0]
            }
         catch {
                    //Handle error
               }
    };return nil
  }

  func fetchSuggestions() async {
    let currentDate = NSDate.now.ISO8601Format()
    do {
      let url = URL(string: "\(Constants.baseURL)suggest.json?countryCode=\(countrycode)&keyword=\(suggestionTerm)&startDateTime=\(currentDate)&size=5&apikey=\(Constants.API_KEY)")
      let (data, _) = try await URLSession.shared.data(from: ((url ?? URL(string:"\(Constants.fallbackURL)"))!))

      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let suggestions = try decoder.decode(Suggestions.self, from: data)
      DispatchQueue.main.async{
        self.suggestions = suggestions.embedded.events
        print("Suggestions loaded!")
      }

    } catch {
      print(String(describing:error))
    }
  }

  func fetchFavourites() async {
    let currentDate = NSDate.now.ISO8601Format()
    do {
      let url = URL(string: "\(Constants.baseURL)events.json?keyword=\(favouriteTerm)&countryCode=\(countrycode)&startDateTime=\(currentDate)&apikey=\(Constants.API_KEY)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
      let (data, _) = try await URLSession.shared.data(from: ((url ?? URL(string:"\(Constants.fallbackURL)"))!))

      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let favourites = try decoder.decode(Welcome.self, from: data)
      DispatchQueue.main.async{
        self.favourites = favourites.embedded.events
        print("Favourite sublist loaded!")
      }

    } catch {
      DispatchQueue.main.async{
        self.favourites = [Event]()
        print("Favourite sublist cleared!")
      }
      print(String(describing:error))
    }
  }

}
