//
//  LocalFileManager.swift
//  FunSeeker
//
//  Created by Muhammed Kocabas on 2023-05-26.
//

import Foundation

class LocalFileManager: ObservableObject{

  @Published var offlineEvents = [Event]()

  enum EventType:String {
    case mainfeed = "main-feed"
    case favourites = "favourites"
    case savedevents = "saved-events"
  }

  func saveEventFeed(events: [Event]) {

    guard events.count > 0 else {
      print("Error getting events to save")
      return
    }

    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

    let documentURL = (directoryURL?.appendingPathComponent("main-feed").appendingPathExtension("json"))!

    let jsonEncoder = JSONEncoder()
    let data = try? jsonEncoder.encode(events)

    do {
      try data?.write(to: documentURL, options: .noFileProtection)
    } catch {
      print("Error writing cached events: \(error.localizedDescription)")
    }

  }


  func loadOfflineEvents(eventType:EventType) {

    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let documentURL = (directoryURL?.appendingPathComponent(eventType.rawValue).appendingPathExtension("json"))!

    do {

      let savedData = try Data(contentsOf: documentURL)
      let decoder = JSONDecoder()
      let data = try decoder.decode([Event].self, from: savedData)

      print("We have loaded offline events: \(data.count)")
      DispatchQueue.main.async {
        self.offlineEvents = data
      }


    }catch {
      print("Error writing cached events: \(error.localizedDescription)")
    }
  }

}
