//
//  EventsView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-19.
//

import SwiftUI


struct EventsView: View {

  @ObservedObject var eventViewModel: EventViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
      EventsView(eventViewModel: EventViewModel())
    }
}
