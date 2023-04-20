//
//  FavouriteEventsView.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-19.
//

import SwiftUI

struct FavouriteEventsView: View {

  @ObservedObject var eventViewModel: EventViewModel
    var body: some View {
      VStack{
        ZStack{
          Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        
      }
    }
}

struct FavouriteEventsView_Previews: PreviewProvider {
    static var previews: some View {
      FavouriteEventsView(eventViewModel: EventViewModel())
    }
}

