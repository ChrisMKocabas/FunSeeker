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

// Enum to track the currently focused field in the form
private enum FocusableField: Hashable {
  case email
  case password
}

struct LoginView: View {
  // Access the AuthenticationViewModel from the environment
  @EnvironmentObject var viewModel: AuthenticationViewModel
  @Environment(\.dismiss) var dismiss

  // Track the focus state of the text fields
  @FocusState private var focus: FocusableField?

  // Define a background gradient
  let backgroundGradient = LinearGradient(
    colors: [Color.pink, Color.yellow],
    startPoint: .top, endPoint: .bottom
  )

  // Function to sign in with email and password
  private func signInWithEmailPassword() {
    Task {
      // Await the sign-in operation and dismiss the view if successful
      if await viewModel.signInWithEmailPassword() == true {
        dismiss()
      }
    }
  }

  // Function to reset the password
  private func resetPassword(){
    Task {
      // Await the password reset operation
      await viewModel.resetPassword()
    }
  }

  var body: some View {
    VStack {
      // Display the app logo
      Image("app-logo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(minHeight: 300, maxHeight: 400)

      // Display the "Login" title
      Text("Login")
        .font(.largeTitle)
        .fontWeight(.heavy)
        .fontDesign(.rounded)
        .frame(maxWidth: .infinity, alignment: .leading)

      // Email text field
      HStack {
        SwiftUI.Image(systemName: "at")
        TextField("Email", text: $viewModel.email)
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
          .focused($focus, equals: .email)
          .submitLabel(.next)
          .onSubmit {
            // Set the focus to the password field when the user presses the return key
            self.focus = .password
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 4)

      // Password secure field
      HStack {
        SwiftUI.Image(systemName: "lock")
        SecureField("Password", text: $viewModel.password)
          .focused($focus, equals: .password)
          .submitLabel(.go)
          .onSubmit {
            // Call the sign-in function when the user taps the "Go" button on the keyboard
            signInWithEmailPassword()
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)

      // Display the error message if it is not empty
      if !viewModel.errorMessage.isEmpty {
        VStack {
          Text(viewModel.errorMessage)
            .foregroundColor(Color(UIColor.systemRed))
        }
      }

      // Login button
      Button(action: signInWithEmailPassword) {
        if viewModel.authenticationState != .authenticating {
          // Display the "Login" button when not authenticating
          Text("Login")
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
        else {
          // Display a progress view when authenticating
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
      }
      .disabled(!viewModel.isValid)
      .frame(maxWidth: .infinity)
      .buttonStyle(.borderedProminent)

      VStack {
        // "Don't have an account yet?" text and "Sign up" button
        HStack {
          Text("Don't have an account yet?")
          Button(action: { viewModel.switchFlow() }) {
            Text("Sign up")
              .fontWeight(.semibold)
              .foregroundColor(.blue)
          }
        }

        // "Reset Password" button
        HStack {
          Button(action: { resetPassword() }) {
            Text("Reset Password")
              .fontWeight(.semibold)
              .foregroundColor(.blue)
          }
        }
        .padding([.top], 0.5)
      }
      .padding([.top, .bottom], 50)

    }
    .listStyle(.plain)
    .padding()
    .analyticsScreen(name: "\(Self.self)")
    .background(backgroundGradient.ignoresSafeArea().opacity(0.5))
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      // Preview the light mode
      LoginView()

      // Preview the dark mode
      LoginView()
        .preferredColorScheme(.dark)
    }
    .environmentObject(AuthenticationViewModel())
  }
}
