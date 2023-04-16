////
////  EventModel.swift
////  FunSeeker
////
////  Created by Chris Kocabas on 2023-04-09.
////
//
//import Foundation
//
//// MARK: - Welcome
//struct Welcome: Codable {
//    let embedded: WelcomeEmbedded
//    let links: WelcomeLinks
//    let page: Page
//
//    enum CodingKeys: String, CodingKey {
//        case embedded = "_embedded"
//        case links = "_links"
//        case page
//    }
//}
//
//// MARK: - WelcomeEmbedded
//struct WelcomeEmbedded: Codable {
//    let events: [Event]
//
//}
//
//// MARK: - Event
//struct Event: Codable {
//    let name: String
//    let type: EventType
//    let id: String
//    let test: Bool
//    let url: String
//    let locale: Locale
//    let images: [Image]
//    let sales: Sales
//    let dates: Dates
//    let classifications: [Classification]
//    let promoter: Promoter?
//    let promoters: [Promoter]?
//    let pleaseNote: String?
//    let priceRanges: [PriceRange]?
//    let seatmap: Seatmap?
//    let accessibility: Accessibility?
//    let ticketLimit: TicketLimit?
//    let ageRestrictions: AgeRestrictions?
//    let ticketing: Ticketing?
//    let links: EventLinks
//    let embedded: EventEmbedded
//    let outlets: [Outlet]?
//    let info: String?
//    let products: [Product]?
//
//    enum CodingKeys: String, CodingKey {
//        case name, type, id, test, url, locale, images, sales, dates, classifications, promoter, promoters, pleaseNote, priceRanges, seatmap, accessibility, ticketLimit, ageRestrictions, ticketing
//        case links = "_links"
//        case embedded = "_embedded"
//        case outlets, info, products
//    }
//}
//
//// MARK: - Accessibility
//struct Accessibility: Codable {
//    let ticketLimit: Int?
//    let info: String?
//}
//
//// MARK: - AgeRestrictions
//struct AgeRestrictions: Codable {
//    let legalAgeEnforced: Bool
//}
//
//// MARK: - Classification
//struct Classification: Codable {
//    let primary: Bool
//    let segment, genre, subGenre: Genre
//    let type, subType: Genre?
//    let family: Bool
//}
//
//// MARK: - Genre
//struct Genre: Codable {
//    let id, name: String
//}
//
//// MARK: - Dates
//struct Dates: Codable {
//    let start: Start
//    let timezone: Timezone?
//    let status: Status
//    let spanMultipleDays: Bool
//    let end: End?
//}
//
//// MARK: - End
//struct End: Codable {
//    let localDate: String
//    let approximate, noSpecificTime: Bool
//}
//
//// MARK: - Start
//struct Start: Codable {
//    let localDate: String
//    let localTime: String?
//    let dateTime: Date?
//    let dateTBD, dateTBA, timeTBA, noSpecificTime: Bool
//}
//
//// MARK: - Status
//struct Status: Codable {
//    let code: Code
//}
//
//enum Code: String, Codable {
//    case offsale = "offsale"
//    case onsale = "onsale"
//}
//
//enum Timezone: String, Codable {
//    case americaLosAngeles = "America/Los_Angeles"
//    case americaNewYork = "America/New_York"
//    case americaToronto = "America/Toronto"
//    case americaVancouver = "America/Vancouver"
//}
//
//// MARK: - EventEmbedded
//struct EventEmbedded: Codable {
//    let venues: [Venue]
//    let attractions: [Attraction]
//}
//
//// MARK: - Attraction
//struct Attraction: Codable {
//    let name: String
//    let type: AttractionType
//    let id: String
//    let test: Bool
//    let url: String
//    let locale: Locale
//    let externalLinks: ExternalLinks?
//    let aliases: [String]?
//    let images: [Image]
//    let classifications: [Classification]
//    let upcomingEvents: [String: Int]
//    let links: AttractionLinks
//
//    enum CodingKeys: String, CodingKey {
//        case name, type, id, test, url, locale, externalLinks, aliases, images, classifications, upcomingEvents
//        case links = "_links"
//    }
//}
//
//// MARK: - ExternalLinks
//struct ExternalLinks: Codable {
//    let youtube, twitter, itunes, lastfm: [Facebook]?
//    let facebook, wiki, spotify: [Facebook]?
//    let musicbrainz: [Musicbrainz]?
//    let instagram, homepage: [Facebook]?
//}
//
//// MARK: - Facebook
//struct Facebook: Codable {
//    let url: String
//}
//
//// MARK: - Musicbrainz
//struct Musicbrainz: Codable {
//    let id: String
//}
//
//// MARK: - Image
//struct Image: Codable {
//    let ratio: Ratio
//    let url: String
//    let width, height: Int
//    let fallback: Bool
//    let attribution: Attribution?
//}
//
//enum Attribution: String, Codable {
//    case adjustedImageToAvoidCroppingFaces = "Adjusted image to avoid cropping faces"
//}
//
//enum Ratio: String, Codable {
//    case the16_9 = "16_9"
//    case the3_2 = "3_2"
//    case the4_3 = "4_3"
//}
//
//// MARK: - AttractionLinks
//struct AttractionLinks: Codable {
//    let linksSelf: First
//
//    enum CodingKeys: String, CodingKey {
//        case linksSelf = "self"
//    }
//}
//
//// MARK: - First
//struct First: Codable {
//    let href: String
//}
//
//enum Locale: String, Codable {
//    case enUs = "en-us"
//}
//
//enum AttractionType: String, Codable {
//    case attraction = "attraction"
//}
//
//// MARK: - Venue
//struct Venue: Codable {
//    let name: String
//    let type: VenueType
//    let id: String
//    let test: Bool
//    let url: String?
//    let locale: Locale
//    let images: [Image]?
//    let postalCode: String
//    let timezone: Timezone
//    let city: City
//    let state: State
//    let country: Country
//    let address: Address
//    let location: Location
//    let markets: [Genre]?
//    let dmas: [DMA]?
//    let social: Social?
//    let boxOfficeInfo: BoxOfficeInfo?
//    let parkingDetail, accessibleSeatingDetail: String?
//    let generalInfo: GeneralInfo?
//    let upcomingEvents: UpcomingEvents
//    let links: AttractionLinks
//    let ada: Ada?
//    let aliases: [String]?
//
//    enum CodingKeys: String, CodingKey {
//        case name, type, id, test, url, locale, images, postalCode, timezone, city, state, country, address, location, markets, dmas, social, boxOfficeInfo, parkingDetail, accessibleSeatingDetail, generalInfo, upcomingEvents
//        case links = "_links"
//        case ada, aliases
//    }
//}
//
//// MARK: - Ada
//struct Ada: Codable {
//    let adaPhones, adaCustomCopy, adaHours: String
//}
//
//// MARK: - Address
//struct Address: Codable {
//    let line1: String
//    let line2: String?
//}
//
//// MARK: - BoxOfficeInfo
//struct BoxOfficeInfo: Codable {
//    let phoneNumberDetail: String?
//    let openHoursDetail, acceptedPaymentDetail: String
//    let willCallDetail: String?
//}
//
//// MARK: - City
//struct City: Codable {
//    let name: String
//}
//
//// MARK: - Country
//struct Country: Codable {
//    let name: CountryName
//    let countryCode: CountryCode
//}
//
//enum CountryCode: String, Codable {
//    case ca = "CA"
//}
//
//enum CountryName: String, Codable {
//    case canada = "Canada"
//}
//
//// MARK: - DMA
//struct DMA: Codable {
//    let id: Int
//}
//
//// MARK: - GeneralInfo
//struct GeneralInfo: Codable {
//    let generalRule: String
//    let childRule: String?
//}
//
//// MARK: - Location
//struct Location: Codable {
//    let longitude, latitude: String
//}
//
//// MARK: - Social
//struct Social: Codable {
//    let twitter: Twitter
//}
//
//// MARK: - Twitter
//struct Twitter: Codable {
//    let handle: String
//}
//
//// MARK: - State
//struct State: Codable {
//    let name: StateName
//    let stateCode: StateCode
//}
//
//enum StateName: String, Codable {
//    case britishColumbia = "British Columbia"
//    case ontario = "Ontario"
//    case quebec = "Quebec"
//}
//
//enum StateCode: String, Codable {
//    case bc = "BC"
//    case on = "ON"
//    case qc = "QC"
//}
//
//enum VenueType: String, Codable {
//    case venue = "venue"
//}
//
//// MARK: - UpcomingEvents
//struct UpcomingEvents: Codable {
//    let total, ticketmaster, filtered: Int
//    let tmr: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case total = "_total"
//        case ticketmaster
//        case filtered = "_filtered"
//        case tmr
//    }
//}
//
//// MARK: - EventLinks
//struct EventLinks: Codable {
//    let linksSelf: First
//    let attractions, venues: [First]
//
//    enum CodingKeys: String, CodingKey {
//        case linksSelf = "self"
//        case attractions, venues
//    }
//}
//
//// MARK: - Outlet
//struct Outlet: Codable {
//    let url: String
//    let type: String
//}
//
//// MARK: - PriceRange
//struct PriceRange: Codable {
//    let type: PriceRangeType
//    let currency: Currency
//    let min, max: Double
//}
//
//enum Currency: String, Codable {
//    case cad = "CAD"
//}
//
//enum PriceRangeType: String, Codable {
//    case standard = "standard"
//}
//
//// MARK: - Product
//struct Product: Codable {
//    let name, id: String
//    let url: String
//    let type: String
//    let classifications: [Classification]
//}
//
//// MARK: - Promoter
//struct Promoter: Codable {
//    let id: String
//    let name: PromoterName
//    let description: Description
//}
//
//enum Description: String, Codable {
//    case evenkoCoProWithLiveNationLOCCanadaEast = "EVENKO CO-PRO WITH LIVE NATION / LOC / CANADA EAST"
//    case liveNation3PEEventNtlUsa = "LIVE NATION 3PE EVENT / NTL / USA"
//    case liveNationCanadaLnNtlCan = "LIVE NATION CANADA (LN) / NTL / CAN"
//    case liveNationCanadaRbcNtlCan = "LIVE NATION CANADA-RBC / NTL / CAN"
//    case liveNationMusicNtlUsa = "LIVE NATION MUSIC / NTL / USA"
//    case promotedByVenueNtlUsa = "PROMOTED BY VENUE / NTL / USA"
//}
//
//enum PromoterName: String, Codable {
//    case evenkoCoProWithLiveNation = "EVENKO CO-PRO WITH LIVE NATION"
//    case liveNation3PEEvent = "LIVE NATION 3PE EVENT"
//    case liveNationCanadaLn = "LIVE NATION CANADA (LN)"
//    case liveNationCanadaRbc = "LIVE NATION CANADA-RBC"
//    case liveNationMusic = "LIVE NATION MUSIC"
//    case promotedByVenue = "PROMOTED BY VENUE"
//}
//
//// MARK: - Sales
//struct Sales: Codable {
//    let salesPublic: Public
//    let presales: [Presale]?
//
//    enum CodingKeys: String, CodingKey {
//        case salesPublic = "public"
//        case presales
//    }
//}
//
//// MARK: - Presale
//struct Presale: Codable {
//    let startDateTime, endDateTime: Date
//    let name: String
//    let description: String?
//    let url: String?
//}
//
//// MARK: - Public
//struct Public: Codable {
//    let startDateTime: Date?
//    let startTBD, startTBA: Bool
//    let endDateTime: Date?
//}
//
//// MARK: - Seatmap
//struct Seatmap: Codable {
//    let staticURL: String
//
//    enum CodingKeys: String, CodingKey {
//        case staticURL = "staticUrl"
//    }
//}
//
//// MARK: - TicketLimit
//struct TicketLimit: Codable {
//    let info: String
//}
//
//// MARK: - Ticketing
//struct Ticketing: Codable {
//    let safeTix: SafeTix
//    let healthCheck: HealthCheck?
//}
//
//// MARK: - HealthCheck
//struct HealthCheck: Codable {
//    let summary, description: String
//    let learnMoreURL: String
//
//    enum CodingKeys: String, CodingKey {
//        case summary, description
//        case learnMoreURL = "learnMoreUrl"
//    }
//}
//
//// MARK: - SafeTix
//struct SafeTix: Codable {
//    let enabled: Bool
//}
//
//enum EventType: String, Codable {
//    case event = "event"
//}
//
//// MARK: - WelcomeLinks
//struct WelcomeLinks: Codable {
//    let first, prev, linksSelf, next: First
//    let last: First
//
//    enum CodingKeys: String, CodingKey {
//        case first, prev
//        case linksSelf = "self"
//        case next, last
//    }
//}
//
//// MARK: - Page
//struct Page: Codable {
//    let size, totalElements, totalPages, number: Int
//}
