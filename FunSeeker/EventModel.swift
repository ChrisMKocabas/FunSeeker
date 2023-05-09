//
//  EventModel.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-09.
//
 
import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

// MARK: - Welcome
struct Welcome: Codable {
    let embedded: Embedded
    let links: WelcomeLinks
    let page: Page

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case links = "_links"
        case page
    }
}

struct Suggestions: Codable {
  let links: WelcomeLinks
  let embedded: Embedded

  enum CodingKeys: String, CodingKey {
    case links = "_links"
    case embedded = "_embedded"
  }
}

// MARK: - WelcomeEmbedded
struct Embedded: Codable {
    let events: [Event]

}

// MARK: - Event
struct Event: Codable,Identifiable,Hashable {
  static func == (lhs: Event, rhs: Event) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
  }


  func hash(into hasher: inout Hasher) {
    hasher.combine(id+name)
  }

    let name: String
    let type: String?
    let id: String
    let test: Bool?
    let url: String?
    let locale: String?
    let images: [xImage]
    let sales: Sales?
    let dates: Dates
    let classifications: [Classification]
    let promoter: Promoter?
    let promoters: [Promoter]?
    let info: String?
    let pleaseNote: String?
    let priceRanges: [PriceRange]?
    let products: [Product]?
    let seatmap: Seatmap?
    let accessibility: Accessibility?
    let ticketLimit: TicketLimit?
    let ageRestrictions: AgeRestrictions?
    let ticketing: Ticketing?
    let outlets: [Outlet]?
    let links: EventLinks
    let innerembedded: EventEmbedded?


    enum CodingKeys: String, CodingKey {
        case name, type, id, test, url, locale, images, sales, dates, classifications, promoter, promoters, pleaseNote, priceRanges, seatmap, accessibility, ticketLimit, ageRestrictions, ticketing
        case links = "_links"
        case innerembedded = "_embedded"
        case outlets, info, products
    }
}

// MARK: - Accessibility
struct Accessibility: Codable {
    let ticketLimit: Int?
    let info: String?
}

// MARK: - AgeRestrictions
struct AgeRestrictions: Codable {
    let legalAgeEnforced: Bool
}

// MARK: - Classification
struct Classification: Codable {
    let primary: Bool
    let segment, genre, subGenre: Genre?
    let type, subType: Genre?
    let family: Bool
}

// MARK: - Genre
struct Genre: Codable {
    let id, name: String
}

// MARK: - Dates
struct Dates: Codable {
    let start: Start
    let timezone: String?
    let status: Status
    let spanMultipleDays: Bool
    let end: End?
}

// MARK: - End
struct End: Codable {
    let localDate: String?
    let approximate, noSpecificTime: Bool
}

// MARK: - Start
struct Start: Codable {
    let localDate: String
    let localTime: String?
    let dateTime: String?
    let dateTBD, dateTBA, timeTBA, noSpecificTime: Bool
}

// MARK: - Status
struct Status: Codable {
    let code: String
}

//enum Code: String, Codable {
//    case offsale = "offsale"
//    case onsale = "onsale"
//}

// MARK: - EventEmbedded
struct EventEmbedded: Codable {
    let venues: [Venue]
    let attractions: [Attraction]?
}

// MARK: - Attraction
struct Attraction: Codable {
    let name: String
    let type: AttractionType
    let id: String
    let test: Bool?
    let url: String?
    let locale: String
    let externalLinks: ExternalLinks?
    let aliases: [String]?
    let images: [xImage]
    let classifications: [Classification]
    let upcomingEvents: [String: Int]
    let links: AttractionLinks

    enum CodingKeys: String, CodingKey {
        case name, type, id, test, url, locale, externalLinks, aliases, images, classifications, upcomingEvents
        case links = "_links"
    }
}

// MARK: - ExternalLinks
struct ExternalLinks: Codable {
    let youtube, twitter, itunes, lastfm: [Facebook]?
    let facebook, wiki, spotify: [Facebook]?
    let musicbrainz: [Musicbrainz]?
    let instagram, homepage: [Facebook]?
}

// MARK: - Facebook
struct Facebook: Codable {
    let url: String
}

// MARK: - Musicbrainz
struct Musicbrainz: Codable {
    let id: String
}

// MARK: - Image
struct xImage: Codable {
    let ratio: Ratio?
    let url: String
    let width, height: Int
    let fallback: Bool
    let attribution: String?
}


enum Ratio: String, Codable {
    case the16_9 = "16_9"
    case the3_2 = "3_2"
    case the4_3 = "4_3"
    case the1_1 = "1_1"
}

// MARK: - AttractionLinks
struct AttractionLinks: Codable {
    let linksSelf: First

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - First
struct First: Codable {
    let href: String?
}

//enum Locale: String, Codable {
//    case enUs = "en-us"
//}

enum AttractionType: String, Codable {
    case attraction = "attraction"
}

// MARK: - Venue
struct Venue: Codable {
    let name: String
    let type: String
    let id: String
    let test: Bool?
    let url: String?
    let locale: String
    let images: [xImage]?
    let postalCode: String?
    let timezone: String
    let city: City
    let state: xState
    let country: Country
    let address: Address
    let location: Location?
    let markets: [Genre]?
    let dmas: [DMA]?
    let social: Social?
    let boxOfficeInfo: BoxOfficeInfo?
    let parkingDetail, accessibleSeatingDetail: String?
    let generalInfo: GeneralInfo?
    let upcomingEvents: UpcomingEvents
    let links: AttractionLinks
    let ada: Ada?
    let aliases: [String]?

    enum CodingKeys: String, CodingKey {
        case name, type, id, test, url, locale, images, postalCode, timezone, city, state, country, address, location, markets, dmas, social, boxOfficeInfo, parkingDetail, accessibleSeatingDetail, generalInfo, upcomingEvents
        case links = "_links"
        case ada, aliases
    }
}

// MARK: - Ada
struct Ada: Codable {
    let adaPhones, adaCustomCopy, adaHours: String
}

// MARK: - Address
struct Address: Codable {
    let line1: String?
    let line2: String?
}

// MARK: - BoxOfficeInfo
struct BoxOfficeInfo: Codable {
    let phoneNumberDetail: String?
    let openHoursDetail, acceptedPaymentDetail: String?
    let willCallDetail: String?
}

// MARK: - City
struct City: Codable {
    let name: String
}

// MARK: - Country
struct Country: Codable {
    let name: String
    let countryCode: String
}

//enum CountryCode: String, Codable {
//    case ca = "CA"
//}

//enum CountryName: String, Codable {
//    case canada = "Canada"
//}

// MARK: - DMA
struct DMA: Codable {
    let id: Int
}

// MARK: - GeneralInfo
struct GeneralInfo: Codable {
    let generalRule: String?
    let childRule: String?
}

// MARK: - Location
struct Location: Codable {
    let longitude, latitude: String
}

// MARK: - Social
struct Social: Codable {
    let twitter: Twitter
}

// MARK: - Twitter
struct Twitter: Codable {
    let handle: String
}

// MARK: - State
struct xState: Codable {
    let name: String
    let stateCode: String
}


// MARK: - UpcomingEvents
struct UpcomingEvents: Codable {
    let total, ticketmaster, filtered: Int?
    let tmr: Int?

    enum CodingKeys: String, CodingKey {
        case total = "_total"
        case ticketmaster
        case filtered = "_filtered"
        case tmr
    }
}

// MARK: - EventLinks
struct EventLinks: Codable {
    let linksSelf: First
    let attractions, venues: [First]?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case attractions, venues
    }
}

// MARK: - Outlet
struct Outlet: Codable {
    let url: String?
    let type: String
}

// MARK: - PriceRange
struct PriceRange: Codable {
    let type: String?
    let currency: String
    let min, max: Double
}

//enum Currency: String, Codable {
//    case cad = "CAD"
//}

//enum PriceRangeType: String, Codable {
//    case standard = "standard"
//}

// MARK: - Product
struct Product: Codable {
    let name, id: String
    let url: String
    let type: String
    let classifications: [Classification]
}

// MARK: - Promoter
struct Promoter: Codable {
    let id: String
    let name: String
    let description: String
}

// MARK: - Sales
struct Sales: Codable {
    let salesPublic: Public
    let presales: [Presale]?

    enum CodingKeys: String, CodingKey {
        case salesPublic = "public"
        case presales
    }
}

// MARK: - Presale
struct Presale: Codable {
    let startDateTime, endDateTime: String
    let name: String
    let description: String?
    let url: String?
}

// MARK: - Public
struct Public: Codable {
    let startDateTime: String?
    let startTBD, startTBA: Bool
    let endDateTime: String?
}

// MARK: - Seatmap
struct Seatmap: Codable {
    let staticURL: String

    enum CodingKeys: String, CodingKey {
        case staticURL = "staticUrl"
    }
}

// MARK: - TicketLimit
struct TicketLimit: Codable {
    let info: String
}

// MARK: - Ticketing
struct Ticketing: Codable {
    let safeTix: SafeTix
    let healthCheck: HealthCheck?
}

// MARK: - HealthCheck
struct HealthCheck: Codable {
    let summary, description: String
    let learnMoreURL: String

    enum CodingKeys: String, CodingKey {
        case summary, description
        case learnMoreURL = "learnMoreUrl"
    }
}

// MARK: - SafeTix
struct SafeTix: Codable {
    let enabled: Bool
}

//enum EventType: String, Codable {
//    case event = "event"
//}

// MARK: - WelcomeLinks
struct WelcomeLinks: Codable {
    let first, prev, linksSelf, next: First?
    let last: First?

    enum CodingKeys: String, CodingKey {
        case first, prev
        case linksSelf = "self"
        case next, last
    }
}

// MARK: - Page
struct Page: Codable {
    let size, totalElements, totalPages, number: Int
}





class EventViewModel:ObservableObject {

  struct Constants {
      static let API_KEY = "tgy0mOAGfxD4jSYSX86F0W6OuS33wZ0H"
      static let baseURL = "https://app.ticketmaster.com/discovery/v2/"
      static let fallbackURL = "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=CA&page=0&size=20&apikey=tgy0mOAGfxD4jSYSX86F0W6OuS33wZ0H"
  }

  @Published var events = [Event]()
  @Published var suggestions = [Event]()
  @Published var countrycode:String = "CA"
  @Published var maxPageLoaded:Int=0
  @Published var suggestionTerm: String = ""

  init(){
      print("Initializing")
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
    let url = URL(string: "\(Constants.baseURL)events.json?countryCode=\(countrycode)&startDateTime=2023-05-08T00:00:00Z&sort=date,asc&page=\(pageNo)&size=20&apikey=\(Constants.API_KEY)")!
        let (data, _) = try await URLSession.shared.data(from: url)
//    print("--> data: \(String(describing: String(data: data, encoding: .utf8)))")
        return data
  }

  func fetchSuggestions() async {
    do {
      let url = URL(string: "\(Constants.baseURL)suggest.json?countryCode=\(countrycode)&keyword=\(suggestionTerm)&size=5&apikey=\(Constants.API_KEY)")
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

}
