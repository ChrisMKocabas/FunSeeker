//
//  EventView.swift
//  FunSeeker
//
//  Created by Muhammed Kocabas on 2023-04-20.
//

import SwiftUI



struct EventView: View {

  let item:[Event]
  

    var body: some View {
      VStack{
        Text("\(item[0].id)")
      }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
      EventView(item:PreviewEvents.load(name: "events"))
    }
}
