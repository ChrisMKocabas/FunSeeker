//
//  LocalFileManager.swift
//  FunSeeker
//
//  Created by Muhammed Kocabas on 2023-05-26.
//

import Foundation

class LocalFileManager: ObservableObject{

  // Published property to track the offline events
  @Published var offlineEvents = [Event]()

  // Enum defining the types of event feeds
  enum EventType:String {
    case mainfeed = "main-feed"
    case favourites = "favourites"
    case savedevents = "saved-events"
  }

  // Function to save event feed to local storage
  func saveEventFeed(events: [Event]) {

    guard events.count > 0 else {
      print("Error getting events to save")
      return
    }
    // Get the directory URL for the document directory in the user's domain
    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

    // Construct the document URL for the specific event feed type
    let documentURL = (directoryURL?.appendingPathComponent("main-feed").appendingPathExtension("json"))!

    // Encode events array into JSON data
    let jsonEncoder = JSONEncoder()
    let data = try? jsonEncoder.encode(events)

    do {
      // Write the JSON data to the document URL
      try data?.write(to: documentURL, options: .noFileProtection)
    } catch {
      print("Error writing cached events: \(error.localizedDescription)")
    }

  }

  // Function to load offline events from local storage
  func loadOfflineEvents(eventType:EventType) {
    // Get the directory URL for the document directory in the user's domain
    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

    // Construct the document URL for the specific event feed type
    let documentURL = (directoryURL?.appendingPathComponent(eventType.rawValue).appendingPathExtension("json"))!

    do {
      // Read the data from the document URL
      let savedData = try Data(contentsOf: documentURL)
      let decoder = JSONDecoder()

      // Decode the JSON data into an array of Event objects
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
