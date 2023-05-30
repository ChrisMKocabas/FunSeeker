//
//  AuthenticationView.swift
//  MarsExplorer
//
//  Created by Muhammed Kocabas on 2023-03-02.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

extension AuthenticatedView where Unauthenticated == EmptyView {
  init(@ViewBuilder content: @escaping () -> Content) {
    self.unauthenticated = nil
    self.content = content
  }
}

class ProfileScreenState: ObservableObject {
  @Published var presentingProfileScreen = false
}


struct AuthenticatedView<Content, Unauthenticated>: View where Content: View, Unauthenticated: View {
  @StateObject private var viewModel = AuthenticationViewModel()
  @State private var presentingLoginScreen = false
  @StateObject private var presentingProfileScreen = ProfileScreenState()

  var unauthenticated: Unauthenticated?
  @ViewBuilder var content: () -> Content

  public init(unauthenticated: Unauthenticated?, @ViewBuilder content: @escaping () -> Content) {
    self.unauthenticated = unauthenticated
    self.content = content
  }

  public init(@ViewBuilder unauthenticated: @escaping () -> Unauthenticated, @ViewBuilder content: @escaping () -> Content) {
    self.unauthenticated = unauthenticated()
    self.content = content
  }

  let backgroundGradient = LinearGradient(
      colors: [Color.pink, Color.yellow],
      startPoint: .top, endPoint: .bottom)


  var body: some View {
    switch viewModel.authenticationState {
    case .unauthenticated, .authenticating:
      ZStack{
        backgroundGradient.ignoresSafeArea().opacity(1)
        VStack {
          Image("app-logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(minHeight: 300, maxHeight: 400)
          if let unauthenticated {
            unauthenticated
          }
          else {
            Text("You're not logged in.")  .font(.system(size: 20, weight: .heavy, design: .rounded))
          }
          Button("Tap here to log in") {
            viewModel.reset()
            presentingLoginScreen.toggle()
          } .foregroundColor(.white)
            .font(.system(size: 20, weight: .heavy, design: .rounded))
        }
      }
      .sheet(isPresented: $presentingLoginScreen) {
        AuthenticationView()
          .environmentObject(viewModel)
      }
    case .authenticated: 
      VStack {
        content()
          .environmentObject(viewModel)
          .environmentObject(presentingProfileScreen)
      }
    }
  }
}

struct AuthenticatedView_Previews: PreviewProvider {
  static var previews: some View {
    AuthenticatedView {
      Text("You're signed in.")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(.yellow)
    }
  }
}
