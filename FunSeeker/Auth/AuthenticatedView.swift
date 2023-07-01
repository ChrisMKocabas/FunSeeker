//
//  FunSeekerApp.swift
//  FunSeeker
//
//  Created by Chris Kocabas on 2023-04-09.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

// Extension to provide a default initializer for AuthenticatedView when Unauthenticated is an EmptyView.
extension AuthenticatedView where Unauthenticated == EmptyView {
    init(@ViewBuilder content: @escaping () -> Content) {
        self.unauthenticated = nil
        self.content = content
    }
}

// Observable object to manage the profile screen state.
class ProfileScreenState: ObservableObject {
    @Published var presentingProfileScreen = false
}

// Custom view to handle authenticated and unauthenticated states.
struct AuthenticatedView<Content, Unauthenticated>: View where Content: View, Unauthenticated: View {
    // AuthenticationViewModel instance to handle authentication state.
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var presentingLoginScreen = false
    @StateObject private var presentingProfileScreen = ProfileScreenState()

    var unauthenticated: Unauthenticated?
    @ViewBuilder var content: () -> Content

    // Initializer for AuthenticatedView with an optional unauthenticated view and content view.
    public init(unauthenticated: Unauthenticated?, @ViewBuilder content: @escaping () -> Content) {
        self.unauthenticated = unauthenticated
        self.content = content
    }

    // Initializer for AuthenticatedView with an unauthenticated view closure and content view closure.
    public init(@ViewBuilder unauthenticated: @escaping () -> Unauthenticated, @ViewBuilder content: @escaping () -> Content) {
        self.unauthenticated = unauthenticated()
        self.content = content
    }

    // Background gradient for the view.
    let backgroundGradient = LinearGradient(
        colors: [Color.pink, Color.yellow],
        startPoint: .top, endPoint: .bottom)

    var body: some View {
        switch viewModel.authenticationState {
        case .unauthenticated, .authenticating:
            // If unauthenticated or still authenticating, show the login/signup view.
            ZStack {
                backgroundGradient.ignoresSafeArea().opacity(1)
                VStack {
                    Image("app-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minHeight: 300, maxHeight: 400)
                    if let unauthenticated {
                        unauthenticated
                    } else {
                        Text("You're not logged in.")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                    }
                    Button("Tap here to log in") {
                        viewModel.reset()
                        presentingLoginScreen.toggle()
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                }
            }
            .sheet(isPresented: $presentingLoginScreen) {
                AuthenticationView()
                    .environmentObject(viewModel)
            }
        case .authenticated:
            // If authenticated, show the content view.
            VStack {
                content()
                    .environmentObject(viewModel)
                    .environmentObject(presentingProfileScreen)
            }
        }
    }
}

// Preview for AuthenticatedView.
struct AuthenticatedView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedView {
            Text("You're signed in.")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(.yellow)
        }
    }
}
