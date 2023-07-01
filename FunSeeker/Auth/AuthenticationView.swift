//
//  FunSeekerApp.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-09.
//

import SwiftUI
import Combine
import Firebase
import FirebaseCore
import FirebaseAnalyticsSwift
import FirebaseAuth

// A view responsible for handling authentication
struct AuthenticationView: View {
  @EnvironmentObject var viewModel: AuthenticationViewModel // The view model used for authentication

  var body: some View {
    VStack {
      switch viewModel.flow {
      case .login: // If the flow is set to login
        LoginView() // Show the login view
          .environmentObject(viewModel)
      case .signUp: // If the flow is set to sign up
        SignupView() // Show the signup view
          .environmentObject(viewModel)
      }
    }
  }
}

struct AuthenticationView_Previews: PreviewProvider {
  static var previews: some View {
    AuthenticationView()
      .environmentObject(AuthenticationViewModel()) // Create a preview instance of AuthenticationView with a new AuthenticationViewModel as the environment object
  }
}
