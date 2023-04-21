//
//  FireStoreManager.swift
//  MarsExplorer
//
//  Created by Muhammed Kocabas on 2023-03-27.
//

import Foundation
import Firebase
import FirebaseFirestore




class FirestoreManager: ObservableObject {

  @Published var userEvents: [Event] = []
  @Published var useCloud: Bool =  false


  func fetchUserEvents() {

    guard let currentUser = Auth.auth().currentUser else {
      print("no user signed in")
      // No user is currently signed in
      return
    }
    print(currentUser.uid.description)

    let db = Firestore.firestore()
    let querySnapshot = db.collection("users").document("\(currentUser.uid.description)").collection("events")

    querySnapshot.getDocuments { (snapshot, error) in
      if let error = error {
        print("Error getting documents: \(error.localizedDescription)")
      } else {
        if let snapshot = snapshot {
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

          self.userEvents = models
          // Call the completion handler to indicate that the operation is done
        } else {
          print("No documents found.")

        }
      }
    }
  }

  func saveToFirebase(event:Event) async {
    print("Save to firebase: \(event.id)")
    let user = Auth.auth().currentUser

    let db = Firestore.firestore()

    // Get a reference to the user's document
    let userDocRef = db.collection("users").document(user?.uid ?? "")



    let newEventDocRef = userDocRef.collection("events").document("\(event.id)")
    do {

      let _ = try newEventDocRef.setData(from: event)
  }
    catch{
      print("\(error)")
    }

}
    
    func shouldUseCloud() async {
        if !userEvents.isEmpty {
            DispatchQueue.main.async {
                 self.useCloud = true
             }
           
        }
    }
}
