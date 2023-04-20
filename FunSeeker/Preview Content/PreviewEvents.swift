//
//  PreviewEvents.swift
//  FunSeeker
//
//  Created by Muhammed Kocabas on 2023-04-20.
//

import Foundation

class PreviewEvents{

  static func load(name:String)->[Event]{
    if let path = Bundle.main.path(forResource: name, ofType: "json"){
      do{
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let results = try decoder.decode(Welcome.self, from:data)
        let events = results.embedded.events
        return events
      } catch {
        print("failed to parse \(error)")
        return []
      }
    }
    return []
  }
}
