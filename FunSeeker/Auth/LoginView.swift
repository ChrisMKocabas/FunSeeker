//
//  LoginView.swift
//  MarsExplorer
//
//  Created by Muhammed Kocabas on 2023-03-02.
//

//
// LoginView.swift
// Favourites
//

import SwiftUI
import Combine
import Firebase
import FirebaseCore
import FirebaseAnalyticsSwift
import FirebaseAuth



private enum FocusableField: Hashable {
  case email
  case password
}

struct LoginView: View {
  @EnvironmentObject var viewModel: AuthenticationViewModel
  @Environment(\.dismiss) var dismiss

  @FocusState private var focus: FocusableField?

  let backgroundGradient = LinearGradient(
      colors: [Color.pink, Color.yellow],
      startPoint: .top, endPoint: .bottom)


  private func signInWithEmailPassword() {
    Task {
      if await viewModel.signInWithEmailPassword() == true {
        dismiss()
      }
    }
  }

  private func resetPassword(){
    Task {
      await viewModel.resetPassword()
    }
  }

  

  var body: some View {

    VStack {
      Image("app-logo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(minHeight: 300, maxHeight: 400)
      Text("Login")
        .font(.largeTitle)
        .fontWeight(.heavy)
        .fontDesign(.rounded)
        .frame(maxWidth: .infinity, alignment: .leading)


      HStack {
        SwiftUI.Image(systemName: "at")
        TextField("Email", text: $viewModel.email)
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
          .focused($focus, equals: .email)
          .submitLabel(.next)
          .onSubmit {
            self.focus = .password
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 4)

      HStack {
        SwiftUI.Image(systemName: "lock")
        SecureField("Password", text: $viewModel.password)
          .focused($focus, equals: .password)
          .submitLabel(.go)
          .onSubmit {
            signInWithEmailPassword()
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)

      if !viewModel.errorMessage.isEmpty {
        VStack {
          Text(viewModel.errorMessage)
            .foregroundColor(Color(UIColor.systemRed))
        }
      }

      Button(action: signInWithEmailPassword) {
        if viewModel.authenticationState != .authenticating {
          Text("Login")
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
        else {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
      }
      .disabled(!viewModel.isValid)
      .frame(maxWidth: .infinity)
      .buttonStyle(.borderedProminent)

      VStack{
        HStack {
          Text("Don't have an account yet?")
          Button(action: { viewModel.switchFlow() }) {
            Text("Sign up")
              .fontWeight(.semibold)
              .foregroundColor(.blue)
          }
        }
        HStack {
          Button(action: { resetPassword() }) {
            Text("Reset Password")
              .fontWeight(.semibold)
              .foregroundColor(.blue)
          }
        }.padding([.top], 0.5)
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
      LoginView()
      LoginView()
        .preferredColorScheme(.dark)
    }
    .environmentObject(AuthenticationViewModel())
  }
}
