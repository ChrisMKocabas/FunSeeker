//
//  AuthenticationViewModel.swift
//  MarsExplorer
//
//  Created by Muhammed Kocabas on 2023-03-02.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAnalyticsSwift
import FirebaseAuth
import Combine

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
}

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

enum AuthenticationFlow {
  case login
  case signUp 
}

@MainActor
class AuthenticationViewModel: ObservableObject {
  @Published var email = ""
  @Published var password = ""
  @Published var confirmPassword = ""

  @Published var flow: AuthenticationFlow = .login

  @Published var isValid  = false
  @Published var authenticationState: AuthenticationState = .unauthenticated
  @Published var errorMessage = ""
  @Published var user: User?
  @Published var displayName = ""

    
    
  init() {
    registerAuthStateHandler()

    $flow
      .combineLatest($email, $password, $confirmPassword)
      .map { flow, email, password, confirmPassword in
        flow == .login
          ? !(email.isEmpty || password.isEmpty)
          : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
      }
      .assign(to: &$isValid)

  }

  private var authStateHandler: AuthStateDidChangeListenerHandle?

  func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        self.user = user
        self.authenticationState = user == nil ? .unauthenticated : .authenticated
        self.displayName = user?.email ?? ""
      }
    }
  }

  func switchFlow() {
    flow = flow == .login ? .signUp : .login
    errorMessage = ""
  }

  private func wait() async {
    do {
      print("Wait")
      try await Task.sleep(nanoseconds: 1_000_000_000)
      print("Done")
    }
    catch {
      print(error.localizedDescription)
    }
  }

  func reset() {
    flow = .login
    email = ""
    password = ""
    confirmPassword = ""
  }
}

// MARK: - Email and Password Authentication
extension AuthenticationViewModel {

  func getAuthenticatedUser() throws -> AuthDataResultModel {
      guard let user = Auth.auth().currentUser else {
          throw URLError(.badServerResponse)
      }

      return AuthDataResultModel(user: user)
  }


  func signInWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    do {
      try await Auth.auth().signIn(withEmail: self.email, password: self.password)
      return true
    }
    catch  {
      print(error)
      errorMessage = error.localizedDescription
      authenticationState = .unauthenticated
      return false
    }
  }

  func signUpWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    do  {
        let newUser = try await Auth.auth().createUser(withEmail: email, password: password)
        
        let userUid = newUser.user.uid
        let db = Firestore.firestore()
        try await db.collection("users").document(userUid.description).setData(["userCredentials" : userUid])

        
        
      return true
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
      authenticationState = .unauthenticated
      return false
    }
  }

  func signOut() {
    do {
      try Auth.auth().signOut()
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
    }
  }

  func deleteAccount() async -> Bool {
    do {
        let userUid = user?.uid.description
        let db = Firestore.firestore()
        try await db.collection("users").document(userUid!).delete()
        try await user?.delete() 
        
      return true
    }
    catch {
      errorMessage = error.localizedDescription
      return false
    }
  }

  func resetPassword() async {
    
    if !(email.isEmpty ) {
      do {
        try await Auth.auth().sendPasswordReset(withEmail: email)
        errorMessage = "Password reset email has been sent. Please don't forget to check your spam folder."
      } catch{
        errorMessage = error.localizedDescription
      }
    }
  }

  func updatePassword(password:String, newPassword:String) async -> String {

    do {
      guard let user = Auth.auth().currentUser else { throw URLError(.badServerResponse)}
      let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: password)
      try await user.reauthenticate(with: credential)
      try await user.updatePassword(to: newPassword)
      return ("Password updated successfully!")
    } catch {
      errorMessage = error.localizedDescription
      return(errorMessage)
    }

  }

  func updateEmail(email:String, password: String) async -> String {

    do {
      guard let user = Auth.auth().currentUser else { throw URLError(.badServerResponse)}
      let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: password)
      try await user.reauthenticate(with: credential)
      try await user.updateEmail(to: email)
      displayName = user.email ?? ""
      return ("Email updated successfully!")
    } catch {
      errorMessage = error.localizedDescription
      return(errorMessage)
    }

  }

}
