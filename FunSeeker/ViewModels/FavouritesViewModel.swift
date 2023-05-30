//
//  FavouritesViewModel.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-05-29.
//

import Foundation
import Firebase
import FirebaseFirestore


class FavouritesViewModel: ObservableObject {

  @Published var favouriteEvents: [Event] = []


  //save a favourite event to firebase
  func saveFavourite(event:Event) async {
    print("Save to favourites: \(event.innerembedded?.attractions?.first?.name ?? "")")
    if let attractionName = event.innerembedded?.attractions?[0].name {

      let user = Auth.auth().currentUser
      let db = Firestore.firestore()

      // Get a reference to the user's document
      let userDocRef = db.collection("users").document(user?.uid ?? "")
      let newEventDocRef = userDocRef.collection("favourites").document("\(attractionName)")
      do {

        let _ = try newEventDocRef.setData(from: event)
      }
      catch{
        print("\(error)")
      }

    }
  }

  //save a favourite event to firebase
  func removeFromFavourites(event:Event) async {
    print("Remove from favourites: \(event.innerembedded?.attractions?.first?.name ?? "")")
    if let attractionName = event.innerembedded?.attractions?[0].name {

      let user = Auth.auth().currentUser
      let db = Firestore.firestore()

      // Get a reference to the user's document
      let userDocRef = db.collection("users").document(user?.uid ?? "")
      let newEventDocRef = userDocRef.collection("favourites").document("\(attractionName)")
      do {
        let _ = try await newEventDocRef.delete()

        await fetchUserFavourites()
      }
      catch{
        print("\(error)")
      }

    }
  }

  //firebase collection fetch converted to async
  func fetchUserFavourites() async {

    guard let currentUser = Auth.auth().currentUser else {
      print("no user signed in")
      // No user is currently signed in
      return
    }
    print(currentUser.uid.description)

    let db = Firestore.firestore()
    let querySnapshot = db.collection("users").document("\(currentUser.uid.description)").collection("favourites")

    Task {
      do {
        let snapshot = try await querySnapshot.getDocuments()
        let documents = snapshot.documents
        let models = documents.compactMap { (document) -> Event? in
          do {
            let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
            let model = try JSONDecoder().decode(Event.self, from: jsonData)
            return model
          } catch {
            print("Error decoding document: \(error.localizedDescription)")
            return nil
          }
        }
        DispatchQueue.main.async {
          self.favouriteEvents = models
        }
      }
      catch{
        print("Error decoding document: \(error.localizedDescription)")
      }
    }
  }
}
